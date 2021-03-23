
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../message_type.dart';

class MessageEntity extends Equatable {

  final String id;
  final String creator;
  final String title;
  final String description;
  final String date;
  final MessageType type;
  

  const MessageEntity(this.id, this.creator, this.title, this.description, this.date, this.type);

  Map<String, Object> toJson() {
    return {
      "id": id,
      "creator": creator,
      "title": title,
      "description": description,
      "date": date,
      "type": type,
    };
  }
  
  @override
  List<Object> get props => [id, creator, title, description, date, type];

  @override
  String toString() {
  return 'MessageEntity { id: $id, creator: $creator, title: $title, description: $description, date: $date, type: $type }';
   }

  static MessageEntity fromJson(Map<String, Object> json)
  {
    // Resolves the string to one of the enumerated types.
    MessageType _type = _getType(json['type'] as String);


    return MessageEntity(
      json['id'] as String,
      json['creator'] as String,
      json['title'] as String,
      json['description'] as String,
      json['date'] as String,
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
    
    var temp = snap.data();
    MessageType _type = _getType(temp['type']);

    print(temp);

    return MessageEntity(
      snap.id,
      temp['creator'],
      temp['title'],
      temp['description'],
      temp['date'],
      _type
    );
  }

  Map<String, Object> toDocument() {

    return {
      "creator": creator,
      "title": title,
      "description": description,
      "date": date,
      "type": type,
    };
  }

}