part of 'messaging_bloc.dart';

abstract class MessagingEvent extends Equatable {
  const MessagingEvent();

  @override
  List<Object> get props => [];
}

//class MessageLoadSuccess extends MessagingEvent {}

// class MessageCreated extends MessagingEvent {

//   final Message message;

//   const MessageCreated(this.message);

//   @override
//   List<Object> get props => [message];

//   // ToString
// }

// class MessageUpdated extends MessagingEvent {

//   final Message message;

//   const MessageUpdated(this.message);

//   @override
//   List<Object> get props => [message];

// }

// class MessageDeleted extends MessagingEvent {

//   final Message message;

//   const MessageDeleted(this.message);

//   @override
//   List<Object> get props => [message];

// }

class MessagesUpdated extends MessagingEvent {

  final List<Message> messages;

  const MessagesUpdated(this.messages);

  @override
  List<Object> get props => [messages];

}

// More events when needed...

