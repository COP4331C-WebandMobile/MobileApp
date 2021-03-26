import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/models.dart';
import 'entities/entities.dart';

class ChoresRepository {

   final FirebaseFirestore _fireStore ;
 
  
   ChoresRepository({
    FirebaseFirestore fireStore,
    }) : _fireStore = fireStore ?? FirebaseFirestore.instance;
      

    final choreCollection = FirebaseFirestore.instance.collection('houses').doc('NewHOused').collection("chores");
    final messageCollection = FirebaseFirestore.instance.collection('houses').doc('NewHOused').collection('messages');
  
  Future<void> addNewChore(Chore chore) {
    try{
      choreCollection.add(chore.toEntity().ChoreDocument());
    }
    on Exception {
      print(Exception());
    }
  }
  Future<void> deleteChore(Chore chore) async {
    return choreCollection.doc(chore.id).delete();
  }

  Future<void> markChore(Chore chore) async {
    return choreCollection.doc(chore.id).update({
      "mark": true,
      });
  }
  Stream<List<Chore>> chores() {
    return choreCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Chore.fromEntity(ChoreEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  Future<void> updateChore(Chore update) {
    return choreCollection
        .doc(update.id)
        .set(update.toEntity().ChoreDocument());
  }

   Future<void> CompleteChore(Chore chore) {
    final Timestamp thing = Timestamp.now();

    return messageCollection.doc()
        .set({
            "body": chore.description,
            "creator": chore.creator,
            "date": thing,
            "type": "alert",
            });
  }
}
