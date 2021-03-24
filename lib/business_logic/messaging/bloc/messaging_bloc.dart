import 'dart:async';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:messaging_repository/messaging_repository.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'messaging_event.dart';
part 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {

  final FirebaseMessageRepository _messagingRepository;
  StreamSubscription _messagesSubscription;

  MessagingBloc({
    @required FirebaseMessageRepository messageRepository,
  })
    : assert(messageRepository != null),
      _messagingRepository = messageRepository,
      super(const MessagingState.unkown()) {
        _messagesSubscription = _messagingRepository.messages().listen((messages) => add(MessagesUpdated(messages)),);
      }


  @override
  Stream<MessagingState> mapEventToState(
    MessagingEvent event,
  ) async* {

    if(event is MessagesUpdated)
    {
      yield _mapUpdateMessagesToState(event);
    }
  }

  // 
  MessagingState _mapUpdateMessagesToState(MessagesUpdated event) {

    if(event.messages.isEmpty)
    {
      // Change to No messages state...
      return const MessagingState.empty();
    }
    else if(event.messages.isNotEmpty)
    {
      return MessagingState.updated(event.messages);
    }
    
    return MessagingState.unkown();
  }

  @override 
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }

}
