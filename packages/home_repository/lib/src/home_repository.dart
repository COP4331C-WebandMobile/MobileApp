import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:roomate_repository/roomate_repository.dart';



class InvalidHomeName implements Exception {}
class InvalidPassword implements Exception {}
class HomeExists implements Exception {}
class ServerError implements Exception {}


class HomeRepository {
  final FirebaseFirestore _fireStore;
  final String _email;

  HomeRepository(
    this._email, {
    FirebaseFirestore fireStore,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance;

  Stream<String> home() {
    try {
      return _fireStore
          .collection('users')
          .doc(_email)
          .snapshots()
          .map((snapshot) {
        return snapshot.data()["house_name"];
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> addHome(String houseName, String password) async {
    final snapshot = await _fireStore.collection('houses').doc(houseName).get();
    try{

    if (snapshot.exists) throw HomeExists();

    await _fireStore
        .collection('users')
        .doc(_email)
        .update({"house_name": houseName});

    await _fireStore.collection('houses').doc(houseName).set({
      "creator": _email,
      "password": password,
    });

    await RoomateRepository(houseName).addRoomate(_email);


    } on HomeExists{
      throw HomeExists();
    }
    on Exception {
      throw ServerError();
    }
  }



  Future<void> joinHome(String houseName, String password) async {
    try {
      CollectionReference houseCollection = _fireStore.collection('houses');

      DocumentReference house = houseCollection.doc(houseName);

      await house.get().then((snapShot) {
        if (snapShot.exists) {
          if (snapShot.data()["password"] == password) {
            _fireStore
                .collection('users')
                .doc(_email)
                .update({"house_name": houseName});

            RoomateRepository(houseName).addRoomate(_email);
          } else
            throw InvalidPassword();
        } else {
          throw InvalidHomeName();
        }
      });

    } on InvalidHomeName {
      throw InvalidHomeName();
    } on InvalidPassword {
      throw InvalidPassword();
    }
    on Exception {
      throw Exception();
    }

    return null;
  }
}


