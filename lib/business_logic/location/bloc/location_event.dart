part of 'location_bloc.dart';

// RetreiveUserCurrentLocation (User geopoint)
// SetHouseAdressLocation (House geopoint)
// GetRoomiesLocations (Get a list of all roomates locations.)


abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}


class RetreieveUserLocation extends LocationEvent {
  final UserLocation roomateLocation;

  const RetreieveUserLocation(this.roomateLocation);

  @override
  List<Object> get props => [roomateLocation];
}

class QueryAdresses extends LocationEvent {

  final String houseAdress;

  const QueryAdresses(this.houseAdress);

  @override
  List<Object> get props => [houseAdress];
}

class GetRoomateLocations extends LocationEvent {

  final List<UserLocation> roomateLocations;

  const GetRoomateLocations(this.roomateLocations);

  @override
  List<Object> get props => [roomateLocations];
}
