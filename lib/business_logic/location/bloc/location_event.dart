part of 'location_bloc.dart';

// RetreiveUserCurrentLocation (User geopoint)
// SetHouseAdressLocation (House geopoint)
// GetRoomiesLocations (Get a list of all roomates locations.)


abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}


class GetUserLocation extends LocationEvent {
  final String id;

  const GetUserLocation(this.id);

  @override
  List<Object> get props => [id];
}

class QueryAdresses extends LocationEvent {
  
  final String providedAdress;

  const QueryAdresses(this.providedAdress); 

  @override
  List<Object> get props => [providedAdress];
}

class GetRoomateLocations extends LocationEvent {

  final List<UserLocation> roomateLocations;

  const GetRoomateLocations(this.roomateLocations);

  @override
  List<Object> get props => [roomateLocations];
}