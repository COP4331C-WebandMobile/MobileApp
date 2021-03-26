part of 'messaging_bloc.dart';

@immutable
abstract class MessagingState extends Equatable {
  const MessagingState();
  
  @override
  List<Object> get props => [];
}

class MessagingInitial extends MessagingState {
  const MessagingInitial();
}

class MessagingLoading extends MessagingState {
  const MessagingLoading();
}

class NoMessages extends MessagingState {
  final String errorMessage;
  const NoMessages(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

class MessagesLoaded extends MessagingState {

  final List<Message> messages;
  const MessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];

}

class MessagesError extends MessagingState {

  final String errorMessage;

  const MessagesError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}