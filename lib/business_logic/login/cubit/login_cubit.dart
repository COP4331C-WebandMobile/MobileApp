import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:roomiesMobile/business_logic/authentication/models/models.dart';
import 'package:roomiesMobile/business_logic/settings/cubit/settings_cubit.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const LoginState());

  void emailChanged(String value) {
    
    emit(state.copyWith(email: value));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }


  Future<void> logIn(String user, String password) async
  {
    
    emit(state.copyWith(status: Status.inProgress));

    try {
      await _authenticationRepository.loginStandard(email: user, password: password);

      emit(state.copyWith(status: Status.success));
    }
    on Exception
    {
      emit(state.copyWith(status: Status.failure));

      emit(state.copyWith(status: Status.idle));
    }


  }
  // Google login will be ommitted for now...

}
