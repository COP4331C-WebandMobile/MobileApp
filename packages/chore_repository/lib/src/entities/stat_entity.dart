// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StatEntity extends Equatable {
  final bool mark;
  final String id;
  final String creator;
  final String description;

  const StatEntity(this.description, this.id, this.creator, this.mark);

  @override
  List<Object> get props => [mark, id, creator, description];



  static StatEntity fromSnapshot(DocumentSnapshot snap) {
    return StatEntity(
      snap.data()['first_name'],
      snap.id,
      snap.data()['last_name'],
      snap.data()['email'],
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
