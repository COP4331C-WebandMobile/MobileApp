


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ResponseEntity extends Equatable {

  final String id;
  final String creator;
  final String body;
  final Timestamp postedTime;

  const ResponseEntity(this.id, this.creator, this.body, this.postedTime);

  @override
  List<Object> get props => [id, creator, body];

  static ResponseEntity fromSnapshot(DocumentSnapshot snap) {
    final data =snap.data();

    return ResponseEntity(
      snap.id,
      data['creator'],
      data['body'],
      data['postedTime'],
    );
  }
  
  Map<String, Object> toDocument() {
    return
    {
      "creator": creator,
      "body": body,
      "postedTime": postedTime
    };
  }
}