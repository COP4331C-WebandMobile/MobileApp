part of 'responses_bloc.dart';

abstract class ResponsesEvent extends Equatable {
  const ResponsesEvent();

  @override
  List<Object> get props => [];
}


class SubsribedToResponses extends ResponsesEvent {

    final String messageId;

    const SubsribedToResponses(this.messageId);

    @override
    List<Object> get props => [messageId];
}

class UnsubscribeFromResponses extends ResponsesEvent {

    final String messageId;

    const UnsubscribeFromResponses(this.messageId);

    @override
    List<Object> get props => [messageId];
}


class GetResponses extends ResponsesEvent {

  final String messageId;
  final List<Response> responses;

  const GetResponses(this.responses, this.messageId);

  @override
    List<Object> get props => [responses, messageId];
}