import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/models.dart';
import 'dart:async';
import 'entities/entities.dart';

class ReminderRepository{

  final FirebaseFirestore _fireStore;
  final String _home;

  ReminderRepository(this._home,{
    FirebaseFirestore fireStore,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance;
      
  Stream<List<Reminder>> reminders() {
    try{
      return _fireStore.collection('houses').doc(_home).collection('reminders').snapshots().map((snapshot){
       return snapshot.docs
          .map((doc) => Reminder.fromEntity(ReminderEntity.fromSnapshot(doc)))
          .toList();
      });}
    on Exception catch(e){
      print(e);
    }
      //return list of roomates for the house
      //Update location
  }

Future<void> createReminder(Reminder reminder) {

    try{
     _fireStore.collection('houses').doc(_home).collection("reminders").add(reminder.toEntity().ReminderDocument());
    }
    on Exception {
      print(Exception());
    }

  
}

}