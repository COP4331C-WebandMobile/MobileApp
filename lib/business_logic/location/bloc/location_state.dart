part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();
  
  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LoadingLocations extends LocationState {}

class FailedToRetreiveLocations extends LocationState {}

class SuccessfullyRetreivedLocations extends LocationState { final List<HouseLocation> locations; const SuccessfullyRetreivedLocations(this.locations);}
