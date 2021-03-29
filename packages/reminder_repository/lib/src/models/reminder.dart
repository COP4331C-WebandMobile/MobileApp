import '../entities/entities.dart';
import 'package:equatable/equatable.dart';


class Reminder extends Equatable{

  @override
  List<Object> get props => [frequency,description];

  final description;
  final frequency;


  Reminder(this.description,this.frequency);

  static Reminder fromEntity(ReminderEntity entity) {
    return Reminder(
      entity.description,
      entity.frequency,
    );
  }

  ReminderEntity toEntity() {
    return ReminderEntity(description,frequency);
  }


} 