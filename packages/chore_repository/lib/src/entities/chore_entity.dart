// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChoreEntity extends Equatable {
  final bool mark;
  final String id;
  final String creator;
  final String description;

  const ChoreEntity(this.description, this.id, this.creator, this.mark);

  @override
  List<Object> get props => [mark, id, creator, description];

  @override
  String toString() {
    return 'ChoreEntity { mark: $mark, creator: $creator, description: $description, id: $id }';
  }

  static ChoreEntity fromSnapshot(DocumentSnapshot snap) {
    return ChoreEntity(
      snap.data()['description'],
      snap.id,
      snap.data()['creator'],
      snap.data()['mark'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "mark": mark,
      "description": description,
      "creator": creator,
    };
  }
}
