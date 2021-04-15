part of 'address_location_bloc.dart';

abstract class AddressLocationEvent extends Equatable {
  const AddressLocationEvent();

  @override
  List<Object> get props => [];
}

class GetHomeLocation extends AddressLocationEvent {
  final HouseLocation houseLocation;
  const GetHomeLocation(this.houseLocation);

  @override
  List<Object> get props => [houseLocation];
}

class QueryAddresses extends AddressLocationEvent {
  final String targetAddress;

  const QueryAddresses(this.targetAddress);

  @override
  List<Object> get props => [targetAddress];
}

class SetHomeAddress extends AddressLocationEvent {
  final HouseLocation newHouseLocation;

  const SetHomeAddress(this.newHouseLocation);

  @override
  List<Object> get props => [newHouseLocation];
}
