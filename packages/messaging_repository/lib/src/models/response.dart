

import 'package:equatable/equatable.dart';
import 'package:messaging_repository/src/entities/response_entity.dart';
import 'package:meta/meta.dart';


@immutable
class Response extends Equatable{
  
  final String id;
  final String creator;
  final String body;

  Response(this.id, this.creator,this.body);
 
  Response copyWith({String id, String creator, String body}) {
      return Response(
        id ?? this.id,
        creator ?? this.creator,
        body ?? this.body,
      );
  }

  @override
  List<Object> get props => [id, creator, body];

  @override
  String toString() {
      return 'Response { id: $id, creator: $creator, body: $body }';
    }
  
  ResponseEntity toEntity() {
    return ResponseEntity(id, creator, body);
  }

  static ResponseEntity fromEntity(ResponseEntity entity) {
    return ResponseEntity(
        entity.id,
        entity.creator,
        entity.body,
      );
  }

}