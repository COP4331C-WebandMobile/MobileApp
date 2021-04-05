import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/models.dart';
import 'entities/entities.dart';

class ChoresRepository {
  final FirebaseFirestore _fireStore;
  final String _home;

  ChoresRepository(
    this._home, {
    FirebaseFirestore fireStore,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance;

  final choreCollection = FirebaseFirestore.instance
      .collection('chore')
      .doc('NewHOused')
      .collection("chores");
  final messageCollection = FirebaseFirestore.instance
      .collection('chore')
      .doc('NewHOused')
      .collection('messages');

  Future<void> addNewChore(Chore chore) async {
    try {
      return await _fireStore
          .collection('chore')
          .doc(_home)
          .collection("chores")
          .add(chore.toEntity().toDocument());
    } on Exception {
      print(Exception());
    }
  }

  Future<void> deleteChore(Chore chore) async {
    return await _fireStore
        .collection('chore')
        .doc(_home)
        .collection("chores")
        .doc(chore.id)
        .delete();
  }

  Future<void> markChore(Chore chore) async {
    return await _fireStore
        .collection('chore')
        .doc(_home)
        .collection("chores")
        .doc(chore.id)
        .update({
      "mark": true,
    });
  }

  Future<void> UnMarkChore(Chore chore) async {
    return await _fireStore
        .collection('chore')
        .doc(_home)
        .collection("chores")
        .doc(chore.id)
        .update({
      "mark": false,
    });
  }

  Stream<List<Chore>> chores() {
    return _fireStore
        .collection('chore')
        .doc(_home)
        .collection("chores")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Chore.fromEntity(ChoreEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  Future<void> updateChore(Chore update) async {
    return await _fireStore
        .collection('chore')
        .doc(_home)
        .collection("chores")
        .doc(update.id)
        .set(update.toEntity().toDocument());
  }

  Future<void> completeChore(Chore chore, String email) async {
    final Timestamp date = Timestamp.now();
    int numChores = 1;

    _fireStore.collection('message').doc(_home).collection("messages").add({
      "body": (chore.description + ' completed.'),
      "creator": chore.creator,
      "date": date,
      "type": "MessageType.alert",
    });

    final currentTotal = await _fireStore
        .collection('roomates')
        .doc(_home)
        .collection("roomates")
        .doc(email)
        .get();

    var total = currentTotal.data()['total_chores'];

    await _fireStore    
        .collection("roomates")
        .doc(_home)
        .collection('roomates')
        .doc(email)
        .update({"total_chores": total+1});
  
    final snapshot = await _fireStore
        .collection('roomates')
        .doc(_home)
        .collection("roomates")
        .doc(email)
        .collection("chores")
        .doc(chore.id)
        .get();


    if (snapshot.exists) {
      numChores = snapshot.data()["completed"] + 1;
    }

    await _fireStore
      
        .collection("roomates")
        .doc(_home)
        .collection('roomates')
        .doc(email)
        .collection("chores")
        .doc(chore.id)
        .set({"completed": numChores,
              "description": chore.description});
  }


  Future<Map<String,int>> getChores(String email) async {

  

  }

}
