import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:map_repository/src/entities/user_location_entity.dart';

class UserLocation extends Equatable {
  final String id;
  final GeoPoint location;
  final Timestamp recordedTime;

  UserLocation(this.id, this.location, this.recordedTime);

  UserLocation copyWith(
      {String id, GeoPoint location, Timestamp recordedTime}) {
    return UserLocation(id ?? this.id, location ?? this.location,
        recordedTime ?? this.recordedTime);
  }

  @override
  List<Object> get props => [id, location, recordedTime];

  UserLocationEntity toEntity() {
    return UserLocationEntity(id, location, recordedTime);
  }

  static UserLocation fromEntity(UserLocationEntity entity) {
    return UserLocation(entity.id, entity.location, entity.recordedTime);
  }
}
