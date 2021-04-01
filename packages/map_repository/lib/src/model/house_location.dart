

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:map_repository/src/entities/house_location_entity.dart';



class HouseLocation extends Equatable {

  final String id;
  final String address;
  final GeoPoint longLat;
  
  HouseLocation(this.id, this.address, this.longLat);

  @override
  List<Object> get props => [id, address, longLat];


  HouseLocationEntity toEntity() {
    return HouseLocationEntity(id, address, longLat);
  }

  static HouseLocation fromEntity(HouseLocationEntity entity) {
    return HouseLocation(entity.id, entity.address, entity.longLat);
  }
  

}