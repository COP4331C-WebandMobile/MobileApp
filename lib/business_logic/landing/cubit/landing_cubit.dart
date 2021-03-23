import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';
part 'landing_state.dart';

class LandingCubit extends Cubit<LandingState> {

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<String> _homeSubscription;

  LandingCubit({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
         super(LandingState("sdfds")){
    changeState();
    _homeSubscription = _authenticationRepository.home.listen(
      (home) => emit(LandingState(home)), 
    );
  }
  void changeState() {
    emit(LandingState("new"));
  }
  @override
  Future<void> close() {
    _homeSubscription.cancel();
    return super.close();
  }
}
 