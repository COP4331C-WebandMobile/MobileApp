import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReminderEntity extends Equatable {


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

   Map<String, Object> toDocument() {
    return {
      "description": description,
      "frequency": frequency,
    };
  }
}

