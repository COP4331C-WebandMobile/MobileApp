
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../message_type.dart';

class MessageEntity extends Equatable {

  final String id;
  final String creator;
  final String body;
  final Timestamp date;
  final MessageType type;
  

  const MessageEntity(this.id, this.creator, this.body, this.date, this.type);

  Map<String, Object> toJson() {
    return {
      "id": id,
      "creator": creator,
      "body": body,
      "date": date,
      "type": type,
    };
  }
  
  @override
  List<Object> get props => [id, creator, body, date, type];

  @override
  String toString() {
  return 'MessageEntity { id: $id, creator: $creator, body: $body, date: $date, type: $type }';
   }

  static MessageEntity fromJson(Map<String, Object> json)
  {
    // Resolves the string to one of the enumerated types.
    MessageType _type = _getType(json['type'] as String);


    return MessageEntity(
      json['id'] as String,
      json['creator'] as String,
      json['body'] as String,
      json['date'] as Timestamp,
      _type,
     );
  }

  static MessageType _getType(String type)
  {
    switch (type) {
      case 'alert':
        return MessageType.alert;
        break;
      case 'question':
        return MessageType.question;
        break;
      case 'purchase':
        return MessageType.purchase;
        break;
      default:
        return MessageType.invalid;
    }
  }

  static MessageEntity fromSnapshot(DocumentSnapshot snap) {
    
    var data = snap.data();
    MessageType _type = _getType(data['type']);

    return MessageEntity(
      snap.id,
      data['creator'],
      data['body'],
      data['date'],
      _type
    );
  }

  Map<String, Object> toDocument() {

    return {
      "creator": creator,
      "body": body,
      "date": date,
      "type": type,
    };
  }

}