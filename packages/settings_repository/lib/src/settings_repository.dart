import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/models.dart';
import 'entities/entities.dart';

class SettingsRepository {

   final FirebaseFirestore _fireStore ;
   final String _email; 
  
   SettingsRepository(this._email,{
    FirebaseFirestore fireStore,
    }) : _fireStore = fireStore ?? FirebaseFirestore.instance;

  
    Stream<User> user() {
    try{
      return _fireStore.collection('users').doc(_email).snapshots().map((snapshot){
      return User.fromEntity(UserEntity.fromSnapshot(snapshot));   
      });}
    on Exception catch(e)
    {
      print(e);
    }
      //return list of roomates for the house
      //Update location
  }
  
}
