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

class RespondToQuestion extends MessagingEvent {

  final String id;
  final String creator;
  final String response;

  const RespondToQuestion(this.id, this.creator, this.response);

  @override
  List<Object> get props => [id, creator, response];
}