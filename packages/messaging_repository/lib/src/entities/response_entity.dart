


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ResponseEntity extends Equatable {

  final String id;
  final String creator;
  final String body;

  const ResponseEntity(this.id, this.creator, this.body);

  @override
  List<Object> get props => [id, creator, body];

  static ResponseEntity fromSnapshot(DocumentSnapshot snap) {
    final data =snap.data();

    return ResponseEntity(
      snap.id,
      data['creator'],
      data['body'],
    );
  }
  
  Map<String, Object> toDocument() {
    return
    {
      "creator": creator,
      "body": body,
    };
  }
}