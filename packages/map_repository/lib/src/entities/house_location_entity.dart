import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HouseLocationEntity extends Equatable {

  final String id;
  final String address;
  final GeoPoint longLat;

  HouseLocationEntity(this.id, this.address, this.longLat);

  @override
  List<Object> get props => [id, address, longLat];
  

// TODO: Need to figure out how to generate the id.
static HouseLocationEntity fromJson(Map<String, Object> json)
{ 
  
  var cord = json['coordinates'] as Map<String, Object>;

  return HouseLocationEntity(
    'temp',
    json["matchedAddress"] as String,
    GeoPoint(cord['x'] as double, cord['y'] as double),
  );
}



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