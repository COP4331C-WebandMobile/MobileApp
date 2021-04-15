part of 'address_location_bloc.dart';

abstract class AddressLocationState extends Equatable {
  const AddressLocationState();

  @override
  List<Object> get props => [];
}

class AddressLocationInitial extends AddressLocationState {}

class SuccessfullyRetreievedAddresses extends AddressLocationState {
  final List<HouseLocation> houseLocations;

  const SuccessfullyRetreievedAddresses(this.houseLocations);

  @override
  List<Object> get props => [houseLocations];
}

class FailureToRetreiveAddresses extends AddressLocationState {}

class HomeAddressUpdated extends AddressLocationState {
  final HouseLocation houseLocation;
  const HomeAddressUpdated(this.houseLocation);

  @override
  List<Object> get props => [houseLocation];
}

class SuccessfullySetHome extends AddressLocationState {}

class FailureToSetHome extends AddressLocationState {}

class FailureToRetreiveHome extends AddressLocationState { }

class LoadingLocationData extends AddressLocationState {}