

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class House extends Equatable {

  // Not sure but most likely there would be a Chore and House Item model.
  // Which would mean we could store a list of Chore models and what not.
  // But there would have to create a function to handle creating the chores then adding them to the chore list.
  final List<String> chores;
  final List<String> houseItems;

  const House({
    @required this.chores,
    @required this.houseItems,
  }) : assert(chores != null);

  @override
  List<Object> get props => [chores, houseItems];

}