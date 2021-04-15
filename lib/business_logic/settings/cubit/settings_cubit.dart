import 'dart:async';
//import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:roomiesMobile/business_logic/authentication/authentication.dart';
import 'package:roomiesMobile/business_logic/authentication/models/name.dart';
import 'package:roomiesMobile/business_logic/authentication/models/phoneNumber.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  StreamSubscription _settingsSubscription;
  final SettingsRepository _settingsRepository;

  SettingsCubit({
    @required SettingsRepository settingsRepository,
  })  : assert(settingsRepository != null),
        _settingsRepository = settingsRepository,
        super(SettingsState()) {
    settings();
  }

  void settings() {
    _settingsSubscription = _settingsRepository
        .user()
        .listen((settings) => emit(SettingsState(user: settings)));
  }

 void changeFirstName(String firstName) {
      _settingsRepository.changeFirstName(firstName);
  }

  void changeLastName(String lastName) {
    _settingsRepository.changeLastName(lastName);
  }

  void changePhoneNumber(String phoneNumber) {
    _settingsRepository.changePhoneNumber(phoneNumber);
  }

  void leaveHome() {
    _settingsRepository.leaveHome();
  }

  void onLastNameChanged(String value) {
    final lastName = Name.dirty(value);

    emit(state.copyWith(
      last: lastName,
      status: Formz.validate([
        lastName,
      ]),
    ));
  }

  void onFirstNameChanged(String value) {
    final firstName = Name.dirty(value);

    emit(state.copyWith(
      first: firstName,
      status: Formz.validate([
        firstName,
      ]),
    ));
  }

  void onPhoneNumberChanged(String value) {
    final phoneNumber = PhoneNumber.dirty(value);

    emit(state.copyWith(
      phoneNumber: phoneNumber,
      status: Formz.validate([
        phoneNumber,
      ]),
    ));
  }

  void onEmailChanged(String value) {
    final email = Email.dirty(value);

    emit(state.copyWith(
      phoneNumber: state.phoneNumber,
      email: email,
      status: Formz.validate([email]),
    ));
  }

  void onNewPasswordChanged(String value) {
    final newPassword = Password.dirty(value);

    emit(state.copyWith(
      newPassword: newPassword,
      status: Formz.validate([newPassword]),
    ));
  }

  void onNewConfirmedPasswordChanged(String value) {
    final newConfirmedPassword = ConfirmedPassword.dirty(
        password: state.newPassword.value, value: value);
    emit(state.copyWith(
      newConfirmedPassword: newConfirmedPassword,
      status: Formz.validate([newConfirmedPassword]),
    ));
  }

  @override
  Future<void> close() {
    _settingsSubscription.cancel();
    return super.close();
  }
}
