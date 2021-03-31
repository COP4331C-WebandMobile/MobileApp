import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:roomiesMobile/business_logic/authentication/models/models.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {

  final AuthenticationRepository _authenticationRepository;

  LoginCubit(this._authenticationRepository)
    : assert(_authenticationRepository != null),
    super(const LoginState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }
  

  Future<void> logInWithCredentials() async {
    // login has not been validated.
    if(!state.status.isValidated) 
    {
      return;
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    
    try {
    
      await _authenticationRepository.loginStandard(email: state.email.value, password: state.password.value);
      
      // Login success
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    }
    // Failed to login.
    on Exception {

      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  // Google login will be ommitted for now...

}
