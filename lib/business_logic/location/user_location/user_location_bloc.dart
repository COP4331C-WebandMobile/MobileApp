import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:map_repository/map_repository.dart';

part 'user_location_event.dart';
part 'user_location_state.dart';

class UserLocationBloc extends Bloc<UserLocationEvent, UserLocationState> {

  final MapRepository _mapRepository;
  StreamSubscription _userLocationSubscription;

  UserLocationBloc({
    @required MapRepository mapRepository,
  })
  :
  assert(mapRepository != null),
  _mapRepository = mapRepository,
  super(IntializedUserLocation())
  {
    _userLocationSubscription = _mapRepository.userLocations().listen((event) {add(GetRoomateLocations(event));});
  }

  @override
  Stream<UserLocationState> mapEventToState(
    UserLocationEvent event,
  ) async* 
  {

    if(event is GetRoomateLocations)
    {
      yield LoadingLocations(); 

      yield mapGetRoomateLocationsToState(event);
    }
    else if(event is CheckInUserLocation)
    {
      yield await mapCheckInUserToState(event);
    }
  }

  UserLocationState mapGetRoomateLocationsToState(GetRoomateLocations event)
  {
    if(event.roomateLocations.isEmpty)
    {
      return FailureOnRetreiveLocations();
    }
    else
    {
      return SuccessfulOnRetrievedLocations(event.roomateLocations);
    }
  }
  
  Future<UserLocationState> mapCheckInUserToState(CheckInUserLocation event) async
  {
    
    try
    {
      await _mapRepository.recordUserLocation(event.id);

      return SuccessfulToSetLocation();
    }
    on Exception
    {
      return FailureToSetLocation();
    }


  }

  @override
  Future<void> close() {
    _userLocationSubscription.cancel();
    return super.close();
  }
}
