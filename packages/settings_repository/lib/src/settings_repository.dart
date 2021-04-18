import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/models.dart';
import 'entities/entities.dart';

class SettingsRepository {
  final FirebaseFirestore _fireStore;
  final String _email;
  final String _home;

  SettingsRepository(
    this._home,
    this._email, {
    FirebaseFirestore fireStore,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance;

  Stream<User> user() {
    try {
      return _fireStore
          .collection('users')
          .doc(_email)
          .snapshots()
          .map((snapshot) {
        return User.fromEntity(UserEntity.fromSnapshot(snapshot));
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> changeFirstName(String firstName) async {
    await _fireStore
        .collection('users')
        .doc(_email)
        .update({"first_name": firstName});

    await _fireStore
        .collection('roomates')
        .doc(_home)
        .collection('roomates')
        .doc(_email)
        .update({"first_name": firstName});
  }

  Future<void> leaveHome() async {

    try{
    await _fireStore.collection('users').doc(_email).update({"house_name": ""});

    await _fireStore
        .collection('location')
        .doc(_home)
        .collection('locations')
        .doc(_email)
        .delete();

    await _fireStore
        .collection('roomates')
        .doc(_home)
        .collection('roomates')
        .doc(_email)
        .delete();

    await _fireStore
        .collection('roomates')
        .doc(_home)
        .collection('roomates')
        .doc(_email)
        .collection('chores')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    }
    on Exception catch (e)
    {
      print(e);
      throw Exception();
    }
  }

  Future<void> changeLastName(String lastName) async {
    await _fireStore
        .collection('users')
        .doc(_email)
        .update({"last_name": lastName});

    await _fireStore
        .collection('roomates')
        .doc(_home)
        .collection('roomates')
        .doc(_email)
        .update({"last_name": lastName});
  }

  Future<void> changePhoneNumber(String phoneNumber) async {
    await _fireStore
        .collection('users')
        .doc(_email)
        .update({"phone_number": phoneNumber});

    await _fireStore
        .collection('roomates')
        .doc(_home)
        .collection('roomates')
        .doc(_email)
        .update({"phone_number": phoneNumber});
  }
  //return list of roomates for the house
  //Update location
}
