import '../entities/entities.dart';
import 'package:equatable/equatable.dart';


class Reminder extends Equatable{

  @override
  List<Object> get props => [frequency,description,id];

  final description;
  final frequency;
  final id;


  Reminder(this.description,this.frequency,this.id);

  static Reminder fromEntity(ReminderEntity entity) {
    return Reminder(
      entity.description,
      entity.id,
      entity.frequency,
    
    );
  }

  ReminderEntity toEntity() {
    return ReminderEntity(description,frequency,id);
  }


} 