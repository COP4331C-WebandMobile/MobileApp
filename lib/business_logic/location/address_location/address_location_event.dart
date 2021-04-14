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
  final List<HouseLocation> addressList;

  const QueryAddresses(this.addressList);

  @override
  List<Object> get props => [addressList];
}

class SetHomeAddress extends AddressLocationEvent {
  final HouseLocation newHouseLocation;

  const SetHomeAddress(this.newHouseLocation);

  @override
  List<Object> get props => [newHouseLocation];
}
