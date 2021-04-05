part of 'reminders_cubit.dart';

enum ReminderStatus {Loaded, Loading}

class ReminderState extends Equatable {

  final List<Reminder> reminders;
  final status; 

  const ReminderState._({
    this.status,
    this.reminders
  });
 
  @override
  List<Object> get props => [reminders, status];


  const ReminderState.loaded(reminders) : this._(status: ReminderStatus.Loaded,reminders:reminders);
  const ReminderState.loading() : this._(status: ReminderStatus.Loading);
  
}


//const LandingState.homeVerified(String home) : this._(status: HomeStatus.HomeVerified, home: home);

