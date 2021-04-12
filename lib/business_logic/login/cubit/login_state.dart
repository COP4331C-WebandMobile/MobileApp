part of 'login_cubit.dart';

enum Status {idle, success, failure, inProgress}

class LoginState extends Equatable {
  final String email;
  final String password;
  final Status status;

  const LoginState({
    this.email = "",
    this.password = "",
    this.status = Status.idle,
  });

  @override
  List<Object> get props => [email, password, status];

  LoginState copyWith({
    String email,
    String password,
    Status status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}
