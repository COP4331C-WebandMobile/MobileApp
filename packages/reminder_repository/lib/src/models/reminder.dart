import '../entities/entities.dart';

class Reminder{

  final description;
  final lastName;
 
  final lastLocation; 

  Reminder(this.description,this.lastName,this.lastLocation);

    static Reminder fromEntity(ReminderEntity entity) {
    return Reminder(
      entity.firstName,
      entity.lastName,
      entity.lastLocation,
    );
  }


} 