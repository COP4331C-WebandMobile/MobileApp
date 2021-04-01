import 'dart:async';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:map_repository/map_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  
  final MapRepository _mapRepository;

  LocationBloc({
    @required MapRepository mapRepository,
  }) 
  : 
  assert(mapRepository != null),
  _mapRepository = mapRepository,
  super(LocationInitial());

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* 
  {
    if(event is GetRoomateLocations)
    {
      
    }
    else if(event is QueryAdresses)
    {
      
    }
    else if(event is RetreieveUserLocation)
    {


    }

  }
}
