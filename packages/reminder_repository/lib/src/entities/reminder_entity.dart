import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReminderEntity{


  final String firstName;
  final String lastName;
  final String lastLocation;

  const ReminderEntity(this.firstName, this.lastName, this.lastLocation);

  @override
  List<Object> get props => [firstName, lastName, lastLocation];

  static ReminderEntity fromSnapshot(DocumentSnapshot snap) {
    return ReminderEntity(
      snap.data()['description'],
      snap.data()['last_name'],
      snap.data()['last_location'],
    );
  }
}

