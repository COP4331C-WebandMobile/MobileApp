// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChoreEntity extends Equatable {
  final bool complete;
  final String id;
  final String note;
  final String task;

  const ChoreEntity(this.task, this.id, this.note, this.complete);

  @override
  List<Object> get props => [complete, id, note, task];

  @override
  String toString() {
    return 'ChoreEntity { complete: $complete, task: $task, note: $note, id: $id }';
  }

  static ChoreEntity fromSnapshot(DocumentSnapshot snap) {
    return ChoreEntity(
      snap.data()['task'],
      snap.id,
      snap.data()['note'],
      snap.data()['complete'],
    );
  }

  Map<String, Object> ChoreDocument() {
    return {
      "complete": complete,
      "task": task,
      "note": note,
    };
  }
}
