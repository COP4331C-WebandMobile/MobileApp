part of 'responses_bloc.dart';

abstract class ResponsesState extends Equatable {

  final String associatedMessage;

  const ResponsesState(this.associatedMessage);
  
  @override
  List<Object> get props => [associatedMessage];
}

class ResponsesInitial extends ResponsesState { const ResponsesInitial() : super('');}

class SuccessfullyRetreivedResponses extends ResponsesState {

  final String associatedMessage;
  final List<Response> responses;

  const SuccessfullyRetreivedResponses(this.responses, this.associatedMessage) : super(associatedMessage);

  @override
  List<Object> get props => [responses, associatedMessage];  
}

class NoResponsesFound extends ResponsesState { final String associatedMessage; const NoResponsesFound(this.associatedMessage):super(associatedMessage);}

class FailedToRetrieveResponses extends ResponsesState {

  final String associatedMessage;

  const FailedToRetrieveResponses(this.associatedMessage) : super(associatedMessage);

  @override
  List<Object> get props => [associatedMessage]; 
}