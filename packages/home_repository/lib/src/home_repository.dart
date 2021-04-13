import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'entities/entities.dart';
import 'models/models.dart';

class InvalidHomeName implements Exception {}

class InvalidPassword implements Exception {}

class HomeExists implements Exception {}

class ServerError implements Exception {}

class HomeNotFoundException implements Exception {}

class HomeRepository {
  final FirebaseFirestore _fireStore;
  final String _email;

  HomeRepository(
    this._email, {
    FirebaseFirestore fireStore,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance;

  Stream<String> home() {
    try {
      return  _fireStore.collection('users').doc(_email).snapshots().map((snapshot)  {
       return snapshot.data()["house_name"];
      });
    } on Exception catch (e) {
  
      print(e);
    }
  }

  Future<Home>getInfo(String home) async {

    final snapshot = await _fireStore.collection('houses').doc(home).get();
    if(snapshot.exists){
    print(snapshot.data()["address"]);
    return Home.fromEntity(HomeEntity.fromSnapshot(snapshot));
    } 
  }

  Future<void> addHome(String homeName, String password, String address) async {
    print(_email);
    print(address);
    print(homeName);
    final snapshot = await _fireStore.collection('houses').doc(homeName).get();
    try {
      if (snapshot.exists) throw HomeExists();

       await _fireStore.collection('houses').doc(homeName).set({
        "creator": _email,
        "password": password,
        "address": address,
      });

      await _fireStore
          .collection('users')
          .doc(_email)
          .update({"house_name": homeName});

     
    } on HomeExists {
      throw HomeExists();
    } on Exception {
      throw ServerError();
    }
  }

  Future<bool> setHomeAdress(String houseName, String newHomeAdress) async
  {

    try {

      final DocumentSnapshot snapshot = await _fireStore.collection('houses').doc(houseName).get();

      if(snapshot.exists)
      {
        await _fireStore.collection('houses').doc(houseName).update({"address": newHomeAdress});

        return true;
      }
      else
      {
        throw HomeNotFoundException();
      }

    }
    on Exception catch(e, stacktrace)
    {
      print(e.toString());
      print(stacktrace);
    }

    return false;
  }

  Future<String> getHomeAddress(String houseName) async
  {

    try
    {
      final DocumentSnapshot snapshot = await _fireStore.collection('houses').doc(houseName).get();

      if(snapshot.exists)
      {
        return snapshot.data()['address'];
      }
      else
      {
        throw HomeNotFoundException();
      }

    }
    on Exception catch(e, stacktrace)
    {
      print(e);
      print(stacktrace);
    }

    return '';
  }

  Future<void> joinHome(String homeName, String password) async {
    try {
      CollectionReference homeCollection = _fireStore.collection('houses');

      DocumentReference home = homeCollection.doc(homeName);

      await home.get().then((snapShot) {
        if (snapShot.exists) {
          if (snapShot.data()["password"] == password) {
            _fireStore
                .collection('users')
                .doc(_email)
                .update({"house_name": homeName});
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
    } on Exception {
      throw Exception();
    }

    return null;
  }
}
