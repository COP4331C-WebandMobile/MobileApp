part of 'register_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class RegisterState extends Equatable {

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final PhoneNumber phoneNumber;
  final Name firstName;
  final Name lastName;
  final FormzStatus status;

  const RegisterState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.firstName = const Name.pure(),
    this.lastName = const Name.pure(),
    this.status = FormzStatus.pure,
  });

  @override
  List<Object> get props => [email, password, confirmedPassword, phoneNumber, firstName, lastName, status];

  RegisterState copyWith({
    Email email,
    Password password,
    ConfirmedPassword confirmedPassword,
    PhoneNumber phoneNumber,
    Name firstName,
    Name lastName,
    FormzStatus status,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName:  lastName ?? this.lastName,
      status: status ?? this.status,
    );
  }
}