

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class HouseItem extends Equatable {

  final String itemId;
  final String name;
  final String contributors;
  final String cost;

  const HouseItem({
    @required this.itemId,
    @required this.name,
    this.contributors,
    this.cost,
  }) : assert(itemId != null), assert(name != null);

  @override
  List<Object> get props => [itemId, name, contributors, cost];

}