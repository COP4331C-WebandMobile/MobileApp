part of 'password_reset_cubit.dart';

class PasswordResetState extends Equatable {

  final Email email;
  final FormzStatus status;

  // Only email is needed to process the password reset...
  const PasswordResetState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
  });

  @override
  List<Object> get props => [email, status];

  PasswordResetState copyWith({
    Email email,
    FormzStatus status,
  }) {
    return PasswordResetState(
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }

}
