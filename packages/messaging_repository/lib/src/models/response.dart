

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:messaging_repository/src/entities/response_entity.dart';
import 'package:meta/meta.dart';


@immutable
class Response extends Equatable{
  
  final String id;
  final String creator;
  final String body;
  final Timestamp postedTime;

  Response(this.id, this.creator,this.body, this.postedTime);
 
  Response copyWith({String id, String creator, String body, String postedTime}) {
      return Response(
        id ?? this.id,
        creator ?? this.creator,
        body ?? this.body,
        postedTime ?? this.postedTime,
      );
  }

  @override
  List<Object> get props => [id, creator, body, postedTime];

  @override
  String toString() {
      return 'Response { id: $id, creator: $creator, body: $body }';
    }
  
  ResponseEntity toEntity() {
    return ResponseEntity(id, creator, body, postedTime);
  }

  static Response fromEntity(ResponseEntity entity) {
    return Response(
        entity.id,
        entity.creator,
        entity.body,
        entity.postedTime
      );
  }

}