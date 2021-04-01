import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/models.dart';
import 'dart:async';
import 'entities/entities.dart';


class RoomateRepository{

  final FirebaseFirestore _fireStore;
  final String _home;

  RoomateRepository(this._home,{
    FirebaseFirestore fireStore,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance;
      
  Stream<List<Roomate>> roomates() {
    try{
      return _fireStore.collection('roomates').doc(_home).collection('roomates').snapshots().map((snapshot){
       return snapshot.docs
          .map((doc) => Roomate.fromEntity(doc.data()["email"],RoomateEntity.fromSnapshot(doc)))
          .toList();
      });}
    on Exception catch(e){
      print(e);
    }
      //return list of roomates for the house     //Update location
  }


  Future<void> addRoomate(String email) async {
    final snapshot = await _fireStore.collection('roomates').doc(_home).collection('roomates').doc(email).get();
    if (snapshot.exists) return;

     RoomateEntity entity =  RoomateEntity.fromSnapshot(snapshot);

     _fireStore.collection('roomates').doc(_home).collection('roomates').doc(email).set(
     Roomate.fromEntity(email,entity).toDocument());
   
}

}
