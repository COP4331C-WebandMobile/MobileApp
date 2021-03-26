import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class HomeRepository {
  final FirebaseFirestore _fireStore;
  final String _email;

  HomeRepository(this._email,{
    FirebaseFirestore fireStore,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance;
      

  Stream<String> home(){ 
    try{
      return _fireStore.collection('users').doc(_email).snapshots().map((snapshot){
      return snapshot.data()["house_name"];}); 
    }
    on Exception catch(e){
      print(e);
    }
  }

  Future<void> addHome(String houseName) async {

    final snapshot = await _fireStore.collection('houses').doc(houseName).get();
    if(snapshot.exists) return;

    _fireStore.collection('users').doc(_email).update({
      "house_name": houseName
      });


   _fireStore.collection('houses').doc(houseName).collection('details').doc().set({
     "creator": _email,
   });

   _fireStore.collection('houses').doc(houseName).set({
     "exists":true,
  });
  }
  }
  