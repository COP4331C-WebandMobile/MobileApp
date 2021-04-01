import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReminderEntity extends Equatable {


  final description;
  final frequency;
  final id;

  const ReminderEntity(this.description,this.frequency,this.id);

  @override
  List<Object> get props => [description, frequency,id];

  static ReminderEntity fromSnapshot(DocumentSnapshot snap) {
    return ReminderEntity(
      snap.data()['description'],
      snap.data()['frequency'],
      snap.id,
    );
  }

   Map<String, Object> toDocument() {
    return {
      "description": description,
      "frequency": frequency,
    };
  }
}

