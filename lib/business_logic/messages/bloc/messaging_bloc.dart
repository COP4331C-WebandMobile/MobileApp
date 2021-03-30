import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:messaging_repository/messaging_repository.dart';

part 'messaging_event.dart';
part 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {

  final FirebaseMessageRepository _messageRepository;
  StreamSubscription _messagesSubscriptions;

  MessagingBloc(this._messageRepository) : super(MessagingInitial()) {
    _messagesSubscriptions = _messageRepository.messages().listen((event) => add(GetMessages(event)));
  }

  @override
  Stream<MessagingState> mapEventToState(
    MessagingEvent event,
  ) async* {

    // This event automatically called by the stream subscription since it is listening to the messages() stream...
    if(event is GetMessages)
    {
      // Loads
      yield MessagingLoading();
      
      //await Future.delayed(Duration(milliseconds: 100));

      if(event.messages.isNotEmpty)
      {
        yield MessagesLoaded(event.messages);
      }
      else
      {
        yield NoMessages('There were no messages to retrieve.');
      } 
    }
    else if(event is RespondToQuestion)
    {
       // Will cause a change to the messages which will create a GetMessages event, so no need to yield a state.
      _messageRepository.respondToQuestion(event.id, event.creator, event.response);
    }
    else if(event is CreateMessage)
    {
      _messageRepository.createNewMessage(event.message);
    }
    else if(event is DeleteMessage)
    {
      _messageRepository.deleteMessage(event.message);
    }
    
  }

  // To prevent memory leak, manually cancel the subscription on closing.
  @override
  Future<void> close() {
    _messagesSubscriptions?.cancel();
    return super.close();
  }  


}
