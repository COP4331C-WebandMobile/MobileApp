
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../message_type.dart';

class MessageEntity extends Equatable {

  final String id;
  final String creator;
  final String body;
  final Timestamp date;
  final MessageType type;
  final String cost;
  
  const MessageEntity(this.id, this.creator, this.body, this.date, this.type, this.cost);
  
  @override
  List<Object> get props => [id, creator, body, date, type, cost];

  @override
  String toString() {
  return 'MessageEntity { id: $id, creator: $creator, body: $body, date: $date, type: $type }';
   }

  static MessageType _getType(String type)
  {
    switch (type) {
      case 'MessageType.alert':
        return MessageType.alert;
        break;
      case 'MessageType.question':
        return MessageType.question;
        break;
      case 'MessageType.purchase':
        return MessageType.purchase;
        break;
      case 'MessageType.anonymous':
        return MessageType.anonymous;
      default:
        return MessageType.invalid;
    }
  }

  static MessageEntity fromSnapshot(DocumentSnapshot snap) {
    
    final data = snap.data();
    MessageType _type = _getType(data['type']);

    return MessageEntity(
      snap.id,
      data['creator'],
      data['body'],
      data['date'],
      _type,
      data['cost'],
    );
  }

  Map<String, Object> toDocument() {

    return {
      "creator": creator,
      "body": body,
      "date": date,
      "type": type.toString(),
      "cost": cost,
    };
  }

}