

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Chore extends Equatable {

  //Fields...
  final String choreId;
  final String name;
  final String description;
  final String creator;

  const Chore({
    @required this.choreId,
    @required this.name,
    @required this.description,
    this.creator
  }) : assert(choreId != null), assert(name != null), assert(description != null);


  @override
  List<Object> get props => [choreId, name, description, creator];

}