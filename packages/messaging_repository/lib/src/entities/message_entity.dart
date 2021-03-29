
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
      _type,
      data['cost'],
    );
  }

  Map<String, Object> toDocument() {

    return {
      "creator": creator,
      "body": body,
      "date": date,
      "type": type,
      "cost": cost,
    };
  }

}