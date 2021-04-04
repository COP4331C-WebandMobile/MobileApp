import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/models.dart';
import 'entities/entities.dart';

class SettingsRepository {

   final FirebaseFirestore _fireStore ;
   final String _email;
   final String _home; 
  
   SettingsRepository(this._home,this._email,{
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
    }}

    void changeFirstName(String firstName){

      _fireStore.collection('users').doc(_email).update({"first_name":firstName});
_fireStore.collection('roomates').doc(_home).collection('roomates').doc(_email).update({"first_name":firstName});

    }

    void changeLastName(String lastName){

       _fireStore.collection('users').doc(_email).update({"last_name":lastName});
      _fireStore.collection('roomates').doc(_home).collection('roomates').doc(_email).update({"last_name":lastName});

    }

    void changePhoneNumber(String phoneNumber){

       _fireStore.collection('users').doc(_email).update({"phone_number":phoneNumber});
         _fireStore.collection('roomates').doc(_home).collection('roomates').doc(_email).update({"phone_number":phoneNumber});

    }
      //return list of roomates for the house
      //Update location
  }
  

