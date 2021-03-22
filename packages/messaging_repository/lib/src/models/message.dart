

import 'package:equatable/equatable.dart';
import 'package:messaging_repository/src/entities/message_entity.dart';
import 'package:meta/meta.dart';

import '../message_type.dart';

@immutable
class Message extends Equatable{
  
  final String id;
  final String creator;
  final String title;
  final String description;
  final String date;
  final MessageType type;

  Message(this.creator, this.date, this.title, {this.type = MessageType.alert, String description = '', String id})
      : this.description = description ?? '',
        this.id = id;

  Message copyWith({String id, String creator, String title, String description, String date, MessageType type}) {
      return Message(
        creator ?? this.creator,
        date ?? this.date,
        title ?? this.title,
        description: description ?? this.description,
        id: id ?? this.id,
        type: type ?? this.type,
      );
  }


  @override
  int get hashCode =>
    creator.hashCode ^ title.hashCode ^ description.hashCode ^ date.hashCode ^ type.hashCode ^ id.hashCode;

  @override
  List<Object> get props => [id, creator, title, description, date, type];

  @override
  String toString() {
      return 'Message { id: $id, creator: $creator, title: $title, description: $description, date: $date, type: $type}';
    }
  
  MessageEntity toEntity() {
    return MessageEntity(id, creator, title, description, date, type);
  }

  static Message fromEntity(MessageEntity entity) {
    return Message(
      entity.creator, 
      entity.date, 
      entity.title,
      id: entity.id,
      );
  }

}