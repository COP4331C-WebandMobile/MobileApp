import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class HomeRepository {
  final FirebaseFirestore _fireStore;
  final String _email;

  HomeRepository(this._email,{
    FirebaseFirestore fireStore,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance;
      
  Stream<String> get home{ 
      
    return _fireStore.collection('users').doc(_email).snapshots().map((snapshot) => snapshot.data()["house_name"]);
      
     
  }
    
  }



  /*
  Future<void> CreateHouse({
    @required String houseName,
    @required String member,
  }) 
  {
      CollectionReference houses = _firestore.collection('houses');
      houses.doc(houseName).collection('roomates').doc('usernames').set({
        'member': FieldValue.arrayUnion([member])
      });

      CollectionReference currentUser = _firestore.collection('users');

      currentUser.doc(member).update({'house_name': houseName});

  }

*/