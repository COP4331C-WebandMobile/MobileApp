

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:messaging_repository/src/entities/message_entity.dart';
import 'package:meta/meta.dart';

import '../message_type.dart';

@immutable
class Message extends Equatable{
  
  final String id;
  final String creator;
  final String body;
  final Timestamp date;
  final MessageType type;

  Message(this.id, this.creator,this.body, this.date, this.type);
 

  Message copyWith({String id, String creator, String body, Timestamp date, MessageType type}) {
      return Message(
        id ?? this.id,
        creator ?? this.creator,
        body ?? this.body,
        date ?? this.date,
        type ?? this.type,
      );
  }

  @override
  List<Object> get props => [id, creator, body, date, type];

  @override
  String toString() {
      return 'Message { id: $id, creator: $creator, body: $body, date: $date, type: $type}';
    }
  
  MessageEntity toEntity() {
    return MessageEntity(id, creator, body, date, type);
  }

  static Message fromEntity(MessageEntity entity) {
    return Message(
        entity.id,
        entity.creator,
        entity.body,
        entity.date,
        entity.type
      );
  }

}