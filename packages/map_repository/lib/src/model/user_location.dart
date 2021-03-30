import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';


class UserLocation extends Equatable {

  final String id;
  final GeoPoint location;
  final Timestamp recordedTime;

  UserLocation(this.id, this.location, this.recordedTime);
  
  


  @override
  List<Object> get props => [];
}
