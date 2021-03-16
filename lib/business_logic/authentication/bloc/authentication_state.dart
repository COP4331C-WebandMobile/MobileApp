part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthenticationState extends Equatable {
  
  final AuthenticationStatus status;
  final User user;
  
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = User.empty,
  });
  
  const AuthenticationState.unkown() : this._();

  const AuthenticationState.authenticated(User user) : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unathenticated() : this._(status: AuthenticationStatus.unauthenticated);


  @override
  List<Object> get props => [status, user];
}
