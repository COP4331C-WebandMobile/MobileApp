import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class AddChoreFailure implements Exception {}

class RemoveChoreFailure implements Exception {}

class AddHouseFailure implements Exception {}

class JoinHouseFailure implements Exception {}

class HomeRepository {
  final FirebaseFirestore _firestore;

  HomeRepository({
    FirebaseFirestore fireStore,
  }) : _firestore = fireStore ?? FirebaseFirestore.instance;

  Future<void> addChore({
    @required String creator,
    @required String description,
    @required String name,
    @required String choreID,
    String toDo,
  }) async {
    //TODO: Implement addChore endpoint...
  }
  Future<void> addHouse({
    @required String houseName,
    @required String member,
  }) async {
    try {
      CollectionReference houses = _firestore.collection('houses');
      houses
          .doc(houseName)
          .collection('roomates')
          .doc('usernames')
          .set({'member': member});
    } on Exception {
      AddHouseFailure();
    }
  }

  Future<void> joinHouse(
      {@required String houseName, @required String member}) async {}
}
