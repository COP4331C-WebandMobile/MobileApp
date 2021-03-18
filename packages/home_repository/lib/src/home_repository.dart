

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class AddChoreFailure implements Exception {}

class RemoveChoreFailure implements Exception {}


class HomeRepository {

  final FirebaseFirestore _firestore;

  HomeRepository({
    FirebaseFirestore fireStore,
  })
  : _firestore = fireStore ?? FirebaseFirestore.instance;

  Future<void> addChore({
    @required String creator,
    @required String description,
    @required String name,
    String toDo,
  }) async {
    
    //TODO: Implement addChore endpoint...
  }

}