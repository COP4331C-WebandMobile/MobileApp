part of 'user_location_bloc.dart';

abstract class UserLocationState extends Equatable {
  const UserLocationState();
  
  @override
  List<Object> get props => [];
}

class IntializedUserLocation extends UserLocationState {}

class LoadingLocations extends UserLocationState {}

class SuccessfulOnRetrievedLocations extends UserLocationState {

  final List<UserLocation> locations;
  
  const SuccessfulOnRetrievedLocations(this.locations);

  @override
  List<Object> get props => [locations];
}

class FailureOnRetreiveLocations extends UserLocationState { }

class FailureToSetLocation extends UserLocationState { }

class SuccessfulToSetLocation extends UserLocationState { }