import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';


class RoomateEntity extends Equatable {
  final firstName;
  final lastName;
  final email;
  final phoneNumber;
  final lastLocation;
 
  const RoomateEntity(this.firstName, this.lastName,this.email,this.phoneNumber, this.lastLocation);

  @override
  List<Object> get props => [firstName, lastName, lastLocation];

  static RoomateEntity fromSnapshot(DocumentSnapshot snap) {
    return RoomateEntity(
      snap.data()['first_name'],
      snap.data()['last_name'],
      snap.data()['email'],
      snap.data()['phoneNumber'],
      snap.data()['last_location'],
    );
  }
}