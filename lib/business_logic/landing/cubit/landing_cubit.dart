import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:home_repository/home_repository.dart';
import 'package:roomate_repository/roomate_repository.dart';

part 'landing_state.dart';

class LandingCubit extends Cubit<LandingState> {
  final HomeRepository _homeRepository;
  StreamSubscription<String> _homeSubscription;

  LandingCubit({
    @required HomeRepository homeRepository,
  })  : assert(homeRepository != null),
        _homeRepository = homeRepository,
        super(LandingState.loading()) {
    emit(LandingState.loading());
    checkHome();
  }

  Future<void> validate(String home) async {
    if (home == "") {
      emit(LandingState.homeless());
    } else {
      Home homeInfo = await _homeRepository.getInfo(home);
      emit(LandingState.homeVerified(home, homeInfo.address));
    }
  }

  void checkHome() {
    _homeSubscription = _homeRepository.home().listen((home) => validate(home));
  }

  Future<void> addHome(
      String houseName, String password, String email, String address) async {
    try {
      await _homeRepository.addHome(houseName, password, address);
      await RoomateRepository(houseName).addRoomate(email);
    } on HomeExists {
      emit(LandingState.error("A home with that name already exists"));
    } on ServerError {
      emit(LandingState.error("Internal Server Error"));
    }
  }

  Future<void> joinHome(String houseName, String password, String email) async {
    try {
      await _homeRepository.joinHome(houseName, password);
      await RoomateRepository(houseName).addRoomate(email);
    } on InvalidPassword {
      emit(LandingState.error("Incorrect Password"));
    } on InvalidHomeName {
      emit(LandingState.error("Home Does not Exist"));
    } on ServerError {
      emit(LandingState.error("Internal Server Error"));
    }
  }

  // Once the address is set, then it is updated via state using the stream.
  Future<void> setAddress(String houseName, String newAddress) async {
    try {
      final bool success =
          await _homeRepository.setHomeAdress(houseName, newAddress);

      if (success) {
        print('Successfully set the new address.');
      } else {
        print('Failed to set the new address.');
      }
    } on Exception catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
  }

  @override
  Future<void> close() {
    _homeSubscription.cancel();
    return super.close();
  }
}
