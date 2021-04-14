import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'google_map_state.dart';

class GoogleMapCubit extends Cubit<GoogleMapState> {

  final Completer<GoogleMapController> _controller;
  BitmapDescriptor _roomateIcon;

  GoogleMapCubit({
    Completer<GoogleMapController> controller,
  }
  ) 
  : 
  assert(controller != null),
  this._controller = controller,
  super(GoogleMapState())
  {
    _init();
  }

  void _init() async
  {
    _roomateIcon = await getRoomateIcon();
    print(_roomateIcon);
  }

  void addRoomateMarker(String id, double longitude, double latitude, DateTime lastKnownTime)
  {
    List<Marker> newMarkers = [];
    
    Marker newMarker = Marker(
      icon: _roomateIcon,
      markerId: MarkerId(id),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: id,
        snippet: 'Last checked in: ${lastKnownTime.month}/${lastKnownTime.day}/${lastKnownTime.year} at ${lastKnownTime.hour}:${lastKnownTime.minute}',
      ),
      onTap: () async { 

          await moveCameraTo(latitude, longitude, zoomAmount: 15);
        },
    );

    final Iterable<Marker> removedDuplicate = state.markers.where((element) => element.markerId != newMarker.markerId);

    newMarkers.addAll(removedDuplicate);

    newMarkers.add(newMarker);

    emit(state.copyWith(markers: newMarkers));
  }
  
  void addAddressMarker(double longitude, double latitude, String address)
  {
    List<Marker> newMarkers = const [];
    
    Marker newMarker = Marker(
      
      markerId: MarkerId('current_home'),
      position: LatLng(latitude, longitude),
    );
    
    final Iterable<Marker> removedDuplicate = state.markers.where((element) => element.markerId != newMarker.markerId);

    newMarkers.addAll(removedDuplicate);

    newMarkers.add(newMarker);

    emit(state.copyWith(markers: newMarkers));
  }
  
  Future<void> moveCameraTo(double latitude, double longitude, {double zoomAmount = 1.0}) async
  {
    final GoogleMapController myController = await _controller.future;

    final LatLng newPosition = LatLng(latitude, longitude);

    final CameraPosition newCameraPosition = CameraPosition(target: newPosition, zoom: zoomAmount);

    myController.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<BitmapDescriptor> getRoomateIcon() async
  {
    return await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), 
      'assets/Roomate_Marker.png',
    );
  }

}
