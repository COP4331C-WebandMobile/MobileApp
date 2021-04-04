import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
   StreamSubscription _settingsSubscription;
   final _settingsRepository;

    SettingsCubit({
    @required SettingsRepository settingsRepository,
  })  :   assert(settingsRepository != null),
         _settingsRepository = settingsRepository,
         super( SettingsState(User("TEst","TEst","TEst","TEst"),status.loading)){
            Settings();
         }
  void Settings(){
    _settingsSubscription = _settingsRepository.user().listen(
    (settings) => emit(SettingsState(settings,status.loaded)));
  }


  void changeFirstName (String firstName) {

    _settingsRepository.changeFirstName(firstName);



  }

  void changeLastName(String lastName) {

    _settingsRepository.changeLastName(lastName);



  }

  void changePhoneNumber(String phoneNumber){

    _settingsRepository.changePhoneNumber(phoneNumber);



  }




   
}