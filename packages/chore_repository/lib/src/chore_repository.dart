import 'dart:async';
import 'dart:developer';
import 'package:meta/meta.dart';

import 'models/chore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ChoreRepository {

   FirebaseFirestore _fireStore;

   ChoreRepository({
    FirebaseFirestore fireStore,
    }) :  _fireStore = fireStore ?? FirebaseFirestore.instance;

    
    // Stream<Chore> get chores{
    //    Stream collectionStream = _fireStore.collection('houses')
    //    .doc('house_name')
    //    .collection("chores")
    //    .then((QuerySnapshot querySnapshot) => {
    //      var choreList = new List<chore>(); 
    //     querySnapshot.docs.forEach((doc) {
            
    //         chore = new chore()
    //         chore.description = doc["description"];
    //         chore.creator = doc["creator"]
    //          choreList.add(doc);
             
    //     });
       
    // });
  }

/*
  Future AddChore<void>(@required Chore ChoreId) {

     collection('house'). add()

  } 

Future DeleteChore<void>(@required Chore ChoreID) {

}

Future MarkChore<void>(@required Chore ChoreID) {

}

Future CompleteChore<void>(@required Chore ChoreID) {

}
*/