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

}

class HouseAdressSet extends LocationEvent {

}

class GetRoomateLocations extends LocationEvent {

  //final List<UserLocationData>

}