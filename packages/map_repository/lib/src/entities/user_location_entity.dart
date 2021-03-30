

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserLocationEntity extends Equatable {

  // Email associated with roomate.
  final String id;
  
  // Last known location.
  final GeoPoint location;

  // Time when location retreived
  final Timestamp recordedTime;

  const UserLocationEntity(this.id, this.location, this.recordedTime);

  @override
  List<Object> get props => [id, location, recordedTime];

  
 static UserLocationEntity fromSnapshot(DocumentSnapshot snap) {
    
    var data = snap.data();

    return UserLocationEntity(
      snap.id,
      data['location'],
      data['lastKnownTime'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "location": location,
      "lastKnownTime": recordedTime,
    };
  }


}