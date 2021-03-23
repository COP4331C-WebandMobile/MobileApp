import 'dart:async';

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


  }


  // 
  Stream<MessagingState> _mapUpdateMessagesToState(MessagesUpdated event) async* {

    _messagesSubscription?.cancel();
    // Cancels subscriptions to make sure we are not double subscribing.
    if(event.messages.isEmpty)
    {
      // Change to No messages state...
    }
    else if(event.messages.isNotEmpty)
    {
      // messages available state...
    }
    
  }

  @override 
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }

}
