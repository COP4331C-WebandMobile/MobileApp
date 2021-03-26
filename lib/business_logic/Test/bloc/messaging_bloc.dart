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
      
      await Future.delayed(Duration(seconds: 1));

      if(event.messages.isNotEmpty)
      {
        yield MessagesLoaded(event.messages);
      }
      else
      {
        yield NoMessages('There were no messages to retrieve.');
      }
      
    }
    
  }




}
