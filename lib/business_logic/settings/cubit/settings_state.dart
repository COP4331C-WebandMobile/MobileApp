part of 'settings_cubit.dart';

enum status {loaded, loading}

class SettingsState extends Equatable {

  final User user;
  final status; 

  SettingsState(this.user,this.status);
 
  @override
  List<Object> get props => [user, status];
  
}



//const LandingState.homeVerified(String home) : this._(status: HomeStatus.HomeVerified, home: home);

//const LandingState.homeless() : this._(status: HomeStatus.Homeless);