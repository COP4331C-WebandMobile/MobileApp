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
      super(MessagesLoadInProgress());


  @override
  Stream<MessagingState> mapEventToState(
    MessagingEvent event,
  ) async* {

    if (event is MessagesLoadInProgress) 
    {
      yield* _mapLoadMessagesToState();
    }
    else if (event is MessageCreated)
    {
      yield* _mapCreateMessageToState(event);
    }
    else if (event is MessageDeleted)
    {
      yield* _mapDeleteMessageToState(event);
    }
    else if (event is MessageUpdated)
    {
      yield* _mapUpdateMessageToState(event);
    }

  }


  Stream<MessagingState> _mapLoadMessagesToState() async* {

    _messagesSubscription?.cancel();
    // Cancels subscriptions to make sure we are not double subscribing.
    _messagesSubscription = _messagingRepository.messages().listen( (messages) => add(MessagesUpdated(messages)));
    
  }

    Stream<MessagingState> _mapCreateMessageToState(MessageCreated event) async* {

      _messagingRepository.createNewMessage(event.message);
  }

   Stream<MessagingState> _mapDeleteMessageToState(MessageDeleted event) async* {

      _messagingRepository.createNewMessage(event.message);
  }

     Stream<MessagingState> _mapUpdateMessageToState(MessageUpdated event) async* {

      _messagingRepository.createNewMessage(event.message);
  }

}
