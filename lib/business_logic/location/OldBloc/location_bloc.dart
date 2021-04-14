import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:map_repository/map_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  
  final MapRepository _mapRepository;
  StreamSubscription _userLocationSubscription;
  StreamSubscription _houseLocationSubscription;

  LocationBloc({
    @required MapRepository mapRepository,
  }) 
  : 
  assert(mapRepository != null),
  _mapRepository = mapRepository,
  super(LocationInitial())
  {
    _userLocationSubscription = _mapRepository.userLocations().listen((event) {add(GetRoomateLocations(event));});
  }

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* 
  {

    if(event is GetUserLocation)
    {
      try {
        await _mapRepository.recordUserLocation(event.id);
        // Yield successful retreived user location.
      }
      on Exception catch(e)
      {
        print(e);
      } 
    }
    else if(event is GetRoomateLocations)
    {
      yield LoadingLocations();
      
      try {
        print('Working???');
        if(event.roomateLocations.isNotEmpty)
        {
          yield SuccessfulToGetRoomates(event.roomateLocations);
        }
        else
          yield FailedToGetLocations();

      }
      on Exception {
        yield FailedToGetLocations();
      }
    }
    else if(event is QueryAdresses)
    {
  
      yield LoadingLocations();

      try {

        List<HouseLocation> adresses = await _mapRepository.fetchAdresses(event.providedAdress);
        
        yield SuccessfulToGetLocations(adresses);
      }
      on Exception catch(e)
      {
        print(e);

        yield FailedToGetLocations();
      }
     
    }
    else if(event is SetAddress)
    {
      try {

        yield SuccessfullySetAddress();
      }
      on Exception catch(e)
      {
        yield FailedSetAddress();
      }

    }
    else if(event is GetAddress)
    {
      final location = await _mapRepository.getHomeGeoLocation();

      final double longitude = location.longitude;
      final double latitude = location.latitude;

      yield SuccessfullyGetAddress(longitude, latitude);
    }
  }
    
  @override
  Future<void> close() {
    _userLocationSubscription?.cancel();
    return super.close();
  }  

}

