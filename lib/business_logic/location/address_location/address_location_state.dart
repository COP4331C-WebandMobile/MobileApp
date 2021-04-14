part of 'address_location_bloc.dart';

abstract class AddressLocationState extends Equatable {
  const AddressLocationState();

  @override
  List<Object> get props => [];
}

class AddressLocationInitial extends AddressLocationState {}

class SuccessfullyRetreievedAddresses extends AddressLocationEvent {
  final List<HouseLocation> houseLocations;

  const SuccessfullyRetreievedAddresses(this.houseLocations);

  @override
  List<Object> get props => [houseLocations];
}

class FailureToRetreiveAddresses extends AddressLocationEvent {}

class HomeAddressUpdated extends AddressLocationEvent {
  final HouseLocation houseLocation;
  const HomeAddressUpdated(this.houseLocation);

  @override
  List<Object> get props => [houseLocation];
}
