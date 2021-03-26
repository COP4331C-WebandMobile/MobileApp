part of 'messaging_bloc.dart';

abstract class MessagingEvent extends Equatable {
  const MessagingEvent();

  @override
  List<Object> get props => [];
}

class GetMessages extends MessagingEvent {

  final List<Message> messages;

  const GetMessages(this.messages);

  @override
  List<Object> get props => [messages];

}