part of 'messaging_bloc.dart';

enum MessageStatus { loading, updated, failure, empty, unkown}

class MessagingState extends Equatable {
  
  final MessageStatus status;
  final List<Message> messages;

  const MessagingState._({
    this.status = MessageStatus.unkown,
    this.messages,
  });

  const MessagingState.unkown() : this._();

  const MessagingState.loading() : this._(status: MessageStatus.loading);

  const MessagingState.updated(List<Message> messages) : this._(status: MessageStatus.updated, messages: messages);

  const MessagingState.empty() : this._(status: MessageStatus.empty);

  @override
  List<Object> get props => [status, messages];
}
