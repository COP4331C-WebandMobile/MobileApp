import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:reminder_repository/reminder_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'reminders_state.dart';



class ReminderCubit extends Cubit<ReminderState> {
   StreamSubscription _reminderSubscription;
   final _reminderRepository;

    ReminderCubit({
    @required ReminderRepository reminderRepository,
  })  :   assert(reminderRepository != null),
         _reminderRepository = reminderRepository,
         super( ReminderState([Reminder("None","None")],status.loading)){
            reminders();
         }
  void reminders(){
    _reminderSubscription = _reminderRepository.reminders().listen(
    (reminders) => emit(ReminderState(reminders,status.loaded)));
  }

  void createReminder(reminderDescription,frequency){
    _reminderRepository.createReminder(Reminder(reminderDescription,frequency));
  }

    @override
  Future<void> close() {
    _reminderSubscription?.cancel();
    return super.close();
  }

}