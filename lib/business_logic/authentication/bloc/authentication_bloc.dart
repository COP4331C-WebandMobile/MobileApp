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
    // return event.user != User.empty
    //     ? AuthenticationState.authenticated(event.user)
    //     : const AuthenticationState.unathenticated();
    if(event.user != User.empty && event.user.isVerified)
    {
      print('Auth');
      return AuthenticationState.authenticated(event.user);
    }
    else
    {
      print('Unauth.');
      return const AuthenticationState.unathenticated();
    }
  }
}
