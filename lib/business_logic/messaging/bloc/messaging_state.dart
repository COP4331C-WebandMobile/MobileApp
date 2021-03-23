part of 'messaging_bloc.dart';

enum MessageStatus { loading, received, failure, unkown}

class MessagingState extends Equatable {
  
  final MessageStatus status;
  final List<Message> messages;

  const MessagingState._({
    this.status = MessageStatus.unkown,
    this.messages,
  });

  const MessagingState.unkown() : this._();

  const MessagingState.loading() : this._(status: MessageStatus.loading);

  const MessagingState.received(List<Message> messages) : this._(status: MessageStatus.received, messages: messages);

  @override
  List<Object> get props => [status, messages];
}
