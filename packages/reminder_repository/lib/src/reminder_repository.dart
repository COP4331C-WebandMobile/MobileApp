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
      return _fireStore.collection('reminders').doc(_home).collection('reminders').snapshots().map((snapshot){
       return snapshot.docs
          .map((doc) => Reminder.fromEntity(ReminderEntity.fromSnapshot(doc)))
          .toList();
      });}
    on Exception catch(e)
    {
      print(e);
    }
      //return list of roomates for the house
      //Update location
  }
Future<void> createReminder(Reminder reminder) async {
    try{
     await _fireStore.collection('reminders').doc(_home).collection("reminders").add(reminder.toEntity().toDocument());
    }
    on Exception {
      print(Exception());
    }

}

Future<void> deleteReminder(Reminder reminder) async {

    try{
      print(reminder.id);
      await _fireStore.collection('reminders').doc(_home).collection("reminders").doc(reminder.id).delete();
    }
    on Exception {
      print(Exception());
    }

}


Future<void> completeReminder(String user,Reminder reminder) {
    final Timestamp date = Timestamp.now();

    return _fireStore.collection('message').doc(_home).collection("messages").add(
           {
            "body": ("Completed " + reminder.frequency + " reminder: " + reminder.description),
            "creator":user,
            "date": date,
            "type": "MessageType.alert",
            });
        
  }


}