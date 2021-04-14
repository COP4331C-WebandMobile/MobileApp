part of 'settings_cubit.dart';


class SettingsState extends Equatable {

  final User user;

  final Name first;
  final Name last;
  final Email email;
  final PhoneNumber phoneNumber;
  final FormzStatus status;

  const SettingsState({
    this.user, 
    this.status = FormzStatus.pure,
    this.first = const Name.pure(),
    this.last = const Name.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.email = const Email.pure(),
  });
 
  @override
  List<Object> get props => [user, status, phoneNumber, email, first, last];

  SettingsState copyWith({
    User user,
    Name first,
    Name last,
    PhoneNumber phoneNumber,
    Email email,
    FormzStatus status,
  })
  {
    return SettingsState(
      user: user ?? this.user,
      first: first ?? this.first,
      last: last ?? this.last,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      status:  status ?? this.status,
    );
  }
  FormzStatus intialize()
  {
    return Formz.validate([first, last, phoneNumber, email]);
  }  

}



//const LandingState.homeVerified(String home) : this._(status: HomeStatus.HomeVerified, home: home);

//const LandingState.homeless() : this._(status: HomeStatus.Homeless);