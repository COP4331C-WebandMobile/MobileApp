import '../entities/entities.dart';
import 'package:equatable/equatable.dart';


class Reminder extends Equatable{

  @override
  List<Object> get props => [frequency,description,id];

  final description;
  final frequency;
  final id;


  Reminder(this.id,this.description,this.frequency);

  static Reminder fromEntity(ReminderEntity entity) {
    return Reminder(
      entity.id,
      entity.description,
      entity.frequency,
    
    );
  }

  ReminderEntity toEntity() {
    return ReminderEntity(description,frequency,id);
  }


} 