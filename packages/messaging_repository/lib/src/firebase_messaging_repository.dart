import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_repository/src/entities/message_entity.dart';
import 'package:messaging_repository/src/messaging_repository.dart';
import 'package:messaging_repository/src/models/message.dart';


class FirebaseMessageRepository implements MessagingRepository {
  
  // Will need to pass the house name to our repo that way we can reference the correct messages collection...
  final messageCollection = FirebaseFirestore.instance.collection('houses').doc('NewHOused').collection('messages');

  @override
  Future<void> createNewMessage(Message message) {
    return messageCollection.add(message.toEntity().toDocument());
  }

  @override
  Future<void> deleteMessage(Message message) {
    return messageCollection.doc(message.id).delete();
  }

  @override
  Future<void> editMessage(Message message) {
    return messageCollection.doc(message.id).update(message.toEntity().toDocument());
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