import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:messaging_repository/messaging_repository.dart';

part 'responses_event.dart';
part 'responses_state.dart';

class ResponsesBloc extends Bloc<ResponsesEvent, ResponsesState> {

  final FirebaseMessageRepository _messageRepository;
  Map<String, StreamSubscription> _responseMap = {};
  

  ResponsesBloc(this._messageRepository) : super(ResponsesInitial());

  @override
  Stream<ResponsesState> mapEventToState(
    ResponsesEvent event,
  ) async* {

    if(event is SubsribedToResponses)
    {
      _responseMap.putIfAbsent(event.messageId, () => _messageRepository.responses(event.messageId).listen((value) {
        add(GetResponses(value, event.messageId));
       }));
    }
    else if(event is UnsubscribeFromResponses)
    {
      final bool retreived = _responseMap.containsKey(event.messageId);

      // Cancel the stream then remove the KVP from the map.
      if(retreived)
      {
        _responseMap[event.messageId].cancel();

        _responseMap.remove(event.messageId);
      }
      else
      {
        print('There was no mapping of this subscription to the message.');
      }

    }
    else if(event is GetResponses)
    {
      if(event.responses.isNotEmpty)
      {
        yield SuccessfullyRetreivedResponses(event.responses, event.messageId);
      }
      else
      {
        yield NoResponsesFound(event.messageId);
      }

    }
  }


  @override
  Future<void> close() {
    _responseMap.forEach((key, value) {value.cancel();});
    return super.close();
  } 

}
