part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

class AuthenticatedUserChanged extends AuthenticationEvent {
  
  final User user;

  const AuthenticatedUserChanged(this.user);

  @override
  List<Object> get props => [user];
}

class AuthenticationChangeEmail extends AuthenticationEvent {
  
  final String email;

  const AuthenticationChangeEmail(this.email);

  @override
  List<Object> get props => [email];
}


class AuthenticationLogoutRequested extends AuthenticationEvent {
  
}

