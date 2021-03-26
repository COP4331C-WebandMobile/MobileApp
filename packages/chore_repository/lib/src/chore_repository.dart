import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/models.dart';
import 'entities/entities.dart';

class ChoresRepository {

   final FirebaseFirestore _fireStore ;
   final String _home; 
   //var _fireStore.instance.collection('houses').doc(_home).collection("chores");
  
   ChoresRepository( this._home,{
    FirebaseFirestore fireStore,
    }) : _fireStore = fireStore ?? FirebaseFirestore.instance;


  Future<void> addNewChore(Chore chore) {
    try{
      _fireStore.collection('houses').doc(_home).collection("chores").add(chore.toEntity().ChoreDocument());
    }
    on Exception {
      print(Exception());
    }
  }

  Future<void> deleteChore(Chore chore) async {
  
    return _fireStore.collection('houses').doc(_home).collection("chores").doc(chore.id).delete();
  }

  Future<void> markChore(Chore chore) async {
    return _fireStore.collection('houses').doc(_home).collection("chores").doc(chore.id).update({
      "mark": true,
      });
  }


   Stream<List<Chore>>chores(){
    return _fireStore.collection('houses').doc(_home).collection("chores").snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Chore.fromEntity(ChoreEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  Future<void> updateChore(Chore update) {
    return _fireStore.collection('houses').doc(_home).collection("chores")
        .doc(update.id)
        .set(update.toEntity().ChoreDocument());
  }

   Future<void> CompleteChore(Chore chore) {

    return _fireStore.collection('houses').doc(_home).collection("messages").add(
           {
            "body": chore.description,
            "creator": chore.creator, 
            "date" : "Dates",
            "type": "alert",
            });
        
  }
  
}
