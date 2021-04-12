part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();
  
  @override
  List<Object> get props => [];
}

// Just for an intial state.
class LocationInitial extends LocationState {}

class LoadingLocations extends LocationState {}

class FailedToGetLocations extends LocationState {}

class SuccessfulToGetLocations extends LocationState { final List<HouseLocation> locations; const SuccessfulToGetLocations(this.locations);}

class SuccessfulToGetRoomates extends LocationState { final List<UserLocation> locations; const SuccessfulToGetRoomates(this.locations);}

class SuccessfullySetAddress extends LocationState {}

class FailedSetAddress extends LocationState {}

class SuccessfullyGetAddress extends LocationState 
{
  final double longitude;
  final double latitude;

  const SuccessfullyGetAddress(this.longitude, this.latitude);

  List<Object> get props => [longitude, latitude];
}