import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/models.dart';
import 'entities/entities.dart';

class ChoresRepository {
  final ChoreCollection = FirebaseFirestore.instance.collection('houses').doc('house_name').collection('chores');


  Future<void> addNewChore(Chore chore) {
    try{
      ChoreCollection.add(chore.toEntity().ChoreDocument());
    }
    on Exception {
      print(Exception());
    }
  }


  Future<void> deleteChore(Chore chore) async {
    return ChoreCollection.doc(chore.id).delete();
  }


  Stream<List<Chore>> chores() {
    return ChoreCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Chore.fromEntity(ChoreEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  Future<void> updateChore(Chore update) {
    return ChoreCollection
        .doc(update.id)
        .set(update.toEntity().ChoreDocument());
  }
}
