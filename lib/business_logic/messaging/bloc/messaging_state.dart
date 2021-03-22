part of 'messaging_bloc.dart';

abstract class MessagingState extends Equatable {
  const MessagingState();
  
  @override
  List<Object> get props => [];
}

class MessagesLoadInProgress extends MessagingState { }

class MessageLoadSuccessful extends MessagingState { 

  final List<Message> messages;

  const MessageLoadSuccessful([this.messages = const []]);

  @override
  List<Object> get props => [messages];

  @override
  String toString() {
      return 'MessagesLoadSuccessful { messages: $messages }';
    }

}

class MessageLoadFailure extends MessagingState { }