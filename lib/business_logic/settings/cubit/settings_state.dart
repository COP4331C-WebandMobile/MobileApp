part of 'settings_cubit.dart';


class SettingsState extends Equatable {

  final User user;

  final Name first;
  final Name last;
  final Email email;
  final PhoneNumber phoneNumber;
  final Password newPassword;
  final ConfirmedPassword newConfirmedPassword;
  final FormzStatus status;

  const SettingsState({
    this.user, 
    this.status = FormzStatus.pure,
    this.first = const Name.pure(),
    this.last = const Name.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.email = const Email.pure(),
    this.newPassword = const Password.pure(),
    this.newConfirmedPassword = const ConfirmedPassword.pure(),
  });
 
  @override
  List<Object> get props => [user, status, phoneNumber, email, first, last, newPassword, newConfirmedPassword];

  SettingsState copyWith({
    User user,
    Name first,
    Name last,
    PhoneNumber phoneNumber,
    Email email,
    Password newPassword,
    ConfirmedPassword newConfirmedPassword,
    FormzStatus status,
  })
  {
    return SettingsState(
      user: user ?? this.user,
      first: first ?? this.first,
      last: last ?? this.last,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      newPassword: newPassword ?? this.newPassword,
      newConfirmedPassword: newConfirmedPassword ?? this.newConfirmedPassword,
      status:  status ?? this.status,
    );
  }
}



//const LandingState.homeVerified(String home) : this._(status: HomeStatus.HomeVerified, home: home);

//const LandingState.homeless() : this._(status: HomeStatus.Homeless);