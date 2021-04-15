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
    if (event.user != User.empty && event.user.isVerified) {
      return AuthenticationState.authenticated(event.user);
    } else {
      return const AuthenticationState.unathenticated();
    }
  }

  bool changeEmail(String email) {
    try {
      _authenticationRepository.changeEmail(email);
    } on RecentAuthenticationFailure {
      return false;
    }
    return true;
  }

  bool changePassword(String password) {
    try {
      _authenticationRepository.changePassword(password);
    } on RecentAuthenticationFailure {
      return false;
    }
    return true;
  }

  Future<bool> deleteAccount(String home) async {
    try {
      await _authenticationRepository.deleteAccount(home);
    } on RecentAuthenticationFailure {
      throw RecentAuthenticationFailure();
    }
    return true;
  }
}
