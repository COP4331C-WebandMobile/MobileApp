import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:map_repository/map_repository.dart';

part 'address_location_event.dart';
part 'address_location_state.dart';

class AddressLocationBloc
    extends Bloc<AddressLocationEvent, AddressLocationState> {
  final MapRepository _mapRepository;
  StreamSubscription _addressLocation;

  AddressLocationBloc({MapRepository mapRepository})
      : assert(mapRepository != null),
        _mapRepository = mapRepository,
        super(AddressLocationInitial()) {
    // Listen to the changes of the home location.
    _addressLocation = _mapRepository.houseLocation().listen((event) {
      add(GetHomeLocation(event));
    });
  }

  @override
  Stream<AddressLocationState> mapEventToState(
    AddressLocationEvent event,
  ) async* {
    if (event is GetHomeLocation) {

      yield LoadingLocationData();

      yield mapGetHomeLocationToState(event);

    } else if (event is SetHomeAddress) {

      yield LoadingLocationData();

      yield await mapSetHomeAddress(event);

    } else if (event is QueryAddresses) {

      yield LoadingLocationData();

      yield await mapQueryAddressesToState(event);
    }
  }

  AddressLocationState mapGetHomeLocationToState (GetHomeLocation event) 
  { 
    if(event.houseLocation != null)
    {
      return HomeAddressUpdated(event.houseLocation);
    }
    else
    {
      return FailureToRetreiveHome();
    }
    

  }

  Future<AddressLocationState> mapSetHomeAddress (SetHomeAddress event) async 
  {
    try
    {
      await _mapRepository.setAddressGeolocation(event.newHouseLocation);

      return SuccessfullySetHome();
    }
    on Exception
    {
      return FailureToSetHome();
    }

  }

  Future<AddressLocationState> mapQueryAddressesToState(QueryAddresses event) async
  {

    try{
      final List<HouseLocation> locations = await _mapRepository.fetchAdresses(event.targetAddress);
      
      if(locations.isEmpty)
      {
        return FailureToRetreiveAddresses();
      }
      else
      {
        return SuccessfullyRetreievedAddresses(locations);
      }

    }
    on Exception
    {
      return FailureToRetreiveAddresses();
    }

  }

  @override
  Future<void> close() {
    _addressLocation?.cancel();
    return super.close();
  }  
}
