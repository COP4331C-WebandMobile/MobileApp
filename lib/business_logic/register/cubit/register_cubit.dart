import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:roomiesMobile/business_logic/authentication/models/models.dart';
import 'package:roomiesMobile/business_logic/authentication/models/name.dart';
import 'package:roomiesMobile/business_logic/authentication/models/phoneNumber.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null), //Must have an authentication repostiory 
        super(const RegisterState()); //Must call the super class

  final AuthenticationRepository _authenticationRepository; //Will be assigned through constructor

  void emailChanged(String value) {
    final email = Email.dirty(value); //Uses formz validation
    emit(state.copyWith( //From the reigster state supercalss 
      email: email,
      status: Formz.validate([
        email,
        state.password,
        state.confirmedPassword,
      ]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(state.copyWith(
      password: password,
      confirmedPassword: confirmedPassword,
      status: Formz.validate([
        state.email,
        password,
        state.confirmedPassword,
      ]),
    ));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
      status: Formz.validate([
        state.email,
        state.password,
        confirmedPassword,
      ]),
    ));
  }
  
  void phoneNumberChanged(String value)
  {
    final phoneNumber = PhoneNumber.dirty(value);

    emit(state.copyWith(
      email: state.email,
      password: state.password,
      confirmedPassword: state.confirmedPassword,
      phoneNumber: phoneNumber,
    ));
  } 

  void firstNameChanged(String value)
  {
    final firstName = Name.dirty(value);

    emit(state.copyWith(
      email: state.email,
      password: state.password,
      confirmedPassword: state.confirmedPassword,
      phoneNumber: state.phoneNumber,
      firstName: firstName,
      lastName: state.lastName,
    ));
  } 

  void lastNameChanged(String value)
  {
    final lastName = Name.dirty(value);

    emit(state.copyWith(
      email: state.email,
      password: state.password,
      confirmedPassword: state.confirmedPassword,
      phoneNumber: state.phoneNumber,
      firstName: state.firstName,
      lastName: lastName,
    ));
  } 

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      
      await _authenticationRepository.register(
        email: state.email.value,
        password: state.password.value,
        firstName: state.firstName.value,
        lastName: state.lastName.value,
        phoneNumber: state.phoneNumber.value,
       );
         
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } 
    on Exception 
    {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
