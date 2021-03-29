import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReminderEntity{


  final description;
  final frequency;

  const ReminderEntity(this.description, this.frequency);

  @override
  List<Object> get props => [description, frequency];

  static ReminderEntity fromSnapshot(DocumentSnapshot snap) {
    return ReminderEntity(
      snap.data()['description'],
      snap.data()['frequency'],
    );
  }

   Map<String, Object> ReminderDocument() {
    return {
      "description": description,
      "frequency": frequency,
    };
  }
}

