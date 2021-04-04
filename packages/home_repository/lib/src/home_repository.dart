import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';


class InvalidHomeName implements Exception {}


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

  Future<void> addHome(String houseName,String password) async {
    final snapshot = await _fireStore.collection('houses').doc(houseName).get();
    if (snapshot.exists) return;

    _fireStore
        .collection('users')
        .doc(_email)
        .update({"house_name": houseName});

   

    _fireStore.collection('houses').doc(houseName).set({
      "creator": _email,
      "password":password,
    });
  }

  Future<void> joinHome(String houseName,String password) {

    try {

      CollectionReference houseCollection = _fireStore.collection('houses');

      DocumentReference house = houseCollection.doc(houseName);

      house.get().then((snapShot) {
        if(snapShot.exists)
        {
          print(snapShot.data()["password"]);
           if(snapShot.data()["password"] == password){
           _fireStore.collection('users').doc(_email).update({"house_name": houseName});
           //RoomateRepository(houseName).addRoomate(_email);
           }
           else return;
        }
        else
        {
          throw InvalidHomeName();
        }
      });
    }
    on Exception
    {
      print('Failed to join home.');
    }

    return null;
  }
}
