import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:home_repository/home_repository.dart';
part 'landing_state.dart';

class LandingCubit extends Cubit<LandingState> {

  final HomeRepository _homeRepository;
  StreamSubscription<String> _homeSubscription;

  LandingCubit({
    @required HomeRepository homeRepository,
  })  : assert(HomeRepository != null),
        _homeRepository = homeRepository,
         super(LandingState("newState")){
    _homeSubscription = _homeRepository.home.listen(
      (home) => emit(LandingState(home)), 
    );
     print("Testing");
  }
  @override
  Future<void> close() {
    _homeSubscription.cancel();
    return super.close();
  }
}
 