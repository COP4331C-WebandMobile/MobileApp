part of 'reminders_cubit.dart';

enum status {loaded, loading}

class ReminderState{

  final List<Reminder> reminders;
  final status; 

  ReminderState(this.reminders,this.status);
 

  @override
  List<Object> get props => [reminders,status];
  
}



//const LandingState.homeVerified(String home) : this._(status: HomeStatus.HomeVerified, home: home);

//const LandingState.homeless() : this._(status: HomeStatus.Homeless);