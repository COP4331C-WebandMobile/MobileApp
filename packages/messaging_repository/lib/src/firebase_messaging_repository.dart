import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:messaging_repository/src/entities/message_entity.dart';
import 'package:messaging_repository/src/entities/response_entity.dart';
import 'package:messaging_repository/src/messaging_repository.dart';
import 'package:messaging_repository/src/models/message.dart';

import 'models/response.dart';

class FirebaseMessageRepository implements MessagingRepository {
  
  final String houseName;
  FirebaseFirestore _firestore;
  CollectionReference messageCollection;

  // Will need to pass the house name to our repo that way we can reference the correct messages collection..
  FirebaseMessageRepository({@required this.houseName})
  {
    // Assuming that the house name is wrong, then it cant find the collection.
    try {
      _firestore = FirebaseFirestore.instance;
      messageCollection = _firestore.collection('message').doc(houseName).collection('messages');
    }
    on Exception {
      throw InvalidHouseNameException();
    }
  }


  @override
  Future<void> createNewMessage(Message message) async {
    
    // Generates a timestamp of the current time when creating a new message.
    return await messageCollection.add(message.copyWith(date: Timestamp.now()).toEntity().toDocument());
  }

  // Parameters: 
  //    - questionId: The id for the question to be responded to.
  //    - creator: The name of the responder.
  //    - response: The response being made to a question.
  Future<void> respondToQuestion(String targetId, String creator, String body) async {

    CollectionReference responses = messageCollection.doc(targetId).collection('/responses');
    
    final reachedMax = await responses.get().then((value) => value.size >= 3);

    // Only allow 3 responses to any question.
    if(reachedMax)
    {
      throw Exception('Too many responses to question');
    }

    final Timestamp time = Timestamp.now();

    final response = ResponseEntity(targetId, creator, body, time);

    
    return await responses.doc().set(response.toDocument());
  } 

  @override
  Future<void> deleteMessage(Message message) {
    return messageCollection.doc(message.id).delete();
  }

  @override
  Future<void> editMessage(Message message) {
    message.copyWith(date: Timestamp.now());

    return messageCollection.doc(message.id).update(message.toEntity().toDocument());
  }

  Stream<List<Response>> responses(String messageId) {
    return _firestore.collection('message').doc(houseName).collection('messages').doc(messageId).collection('responses').snapshots().map((snapshots) {
      return snapshots.docs.map((doc) => Response.fromEntity(ResponseEntity.fromSnapshot(doc))).toList();
    });
  }

  @override
  Stream<List<Message>> messages() {
    return messageCollection.snapshots().map((snapshot){   
      return snapshot.docs
        .map((doc) => Message.fromEntity(MessageEntity.fromSnapshot(doc)))
        .toList();
    });
    
  }

}