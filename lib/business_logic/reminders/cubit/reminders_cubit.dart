import 'dart:async';
import 'package:reminder_repository/reminder_repository.dart';
import 'package:equatable/equatable.dart';
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
         super( ReminderState([Reminder("Testing","Testing","Tesitng")],status.loading)){
            Reminders();
         }
  void Reminders(){
    _reminderSubscription = _reminderRepository.reminders().listen(
    (reminders) => emit(ReminderState(reminders,status.loaded)));
  }
}