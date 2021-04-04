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
  })  :   assert(homeRepository != null),
         _homeRepository = homeRepository,
         super(LandingState.loading()){
            checkHome();
  }

  void validate(String home) {

    if(home=="")
    {
      emit(LandingState.homeless());
    }
    else 
    {
      emit(LandingState.homeVerified(home));
    }

  }
  void checkHome(){
    _homeSubscription = _homeRepository.home().listen(
    (home) => validate(home)); 
  }

  Future<void> addHome(String houseName,String password) async {
    try { 
      await _homeRepository.addHome(houseName,password);
     }
    on HomeExists {
      emit(LandingState.error("A home with that name already exists"));
    } 
    on ServerError {
      emit(LandingState.error("Internal Server Error"));
    }
  }
  
  Future <void> joinHome(String houseName,String password) async {
   
   try{
    await _homeRepository.joinHome(houseName,password);
   } on InvalidPassword{
      emit(LandingState.error("Incorrect Password"));
   } on InvalidHomeName{
      emit(LandingState.error("Home Does not Exist"));

   } on ServerError{
      emit(LandingState.error("Internal Server Error"));
   }
  }

  @override
  Future<void> close() {
    _homeSubscription.cancel();
    return super.close();
  }


 

}
 