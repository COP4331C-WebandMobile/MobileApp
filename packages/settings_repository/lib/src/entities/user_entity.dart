import 'package:cloud_firestore/cloud_firestore.dart';


class UserEntity {
  final firstName;
  final lastName;
  final phoneNumber;
  final email;
 
  const UserEntity(this.firstName, this.lastName,this.email,this.phoneNumber);

  static UserEntity fromSnapshot(DocumentSnapshot snap) {
    return UserEntity(
      snap.data()['first_name'],
      snap.data()['last_name'],
      snap.id,
      snap.data()['phone_number'],
    );
  }
}