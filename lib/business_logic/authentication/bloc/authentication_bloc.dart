import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<User> _userSubscription;

  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unkown()) {
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AuthenticatedUserChanged(user)),
    );
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticatedUserChanged) {
      yield _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      unawaited(_authenticationRepository.logOut());
    } 
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  AuthenticationState _mapAuthenticationUserChangedToState(
    AuthenticatedUserChanged event,
  ) {
    if(event.user != User.empty && event.user.isVerified)
    {
      return AuthenticationState.authenticated(event.user);
    }
    else
    {
      return const AuthenticationState.unathenticated();
    }
  }

  void changeEmail(String email){
     _authenticationRepository.changeEmail(email);
  }

   void changePassword(String password){
     _authenticationRepository.changePassword(password);
  }

  void deleteAccount(){
     _authenticationRepository.deleteAccount();
  }



}
