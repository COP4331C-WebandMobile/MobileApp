

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HouseLocationEntity extends Equatable {

  final String id;
  final String address;
  final GeoPoint longLat;

  HouseLocationEntity(this.id, this.address, this.longLat);

  @override
  List<Object> get props => [id, address, longLat];
  
   
 static HouseLocationEntity fromSnapshot(DocumentSnapshot snap) {
    
    var data = snap.data();

    return HouseLocationEntity(
      snap.id,
      data['address'],
      data['longLat'],
    );
  }
  
  Map<String, Object> toDocument() {
    return {
      "address": address,
      "longLat": longLat,
    };
  }
}