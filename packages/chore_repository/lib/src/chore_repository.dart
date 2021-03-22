import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/models.dart';
import 'entities/entities.dart';

class ChoresRepository {
  final choreCollection = FirebaseFirestore.instance.collection('houses').doc('house_name').collection('chores');


  Future<void> addNewChore(Chore chore) {
    return choreCollection.add(chore.toEntity().choreDocument());
  }


  Future<void> deleteChore(Chore chore) async {
    return choreCollection.doc(chore.id).delete();
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
        .set(update.toEntity().choreDocument());
  }
}
