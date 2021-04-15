import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roomiesMobile/utils/utility_functions.dart';

part 'google_map_state.dart';

class GoogleMapCubit extends Cubit<GoogleMapState> {

  final Completer<GoogleMapController> _controller;

  GoogleMapCubit({
    Completer<GoogleMapController> controller,
  }
  ) 
  : 
  assert(controller != null),
  this._controller = controller,
  super(GoogleMapState());
 


  void addRoomateMarker(String id, double longitude, double latitude, DateTime lastKnownTime)
  {
    List<Marker> newMarkers = [];
    
    Marker newMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      markerId: MarkerId(id),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: id,
        snippet: 'Last checked in: ${UtilityFunctions.formatDate(lastKnownTime)} at ${UtilityFunctions.formatTime(lastKnownTime)}',
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
  
  void addAddressMarker(String address, double latitude, double longitude, {Function onTap})
  {
    List<Marker> newMarkers = [];
    
    Marker newMarker = Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: MarkerId(address),
      position: LatLng(latitude, longitude),
      onTap: onTap,
    );
    
    final Iterable<Marker> removedDuplicate = state.markers.where((element) => element.markerId != newMarker.markerId);
    
    newMarkers.addAll(removedDuplicate);

    newMarkers.add(newMarker);

    emit(state.copyWith(markers: newMarkers,));
  }

  void setHomeMarker(double longitude, double latitude, String address)
  {
    List<Marker> newMarkers = [];
    
    Marker newMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      markerId: MarkerId('current_home'),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: 'Current Home',
        snippet: '$address'
      ),
      onTap: () async {
        await moveCameraTo(latitude, longitude, zoomAmount: 12);
      }
    );
    
    final Iterable<Marker> removedDuplicate = state.markers.where((element) => ((element.markerId != newMarker.markerId) && (element.markerId != MarkerId(address))));

    newMarkers.addAll(removedDuplicate);

    newMarkers.add(newMarker);

    if(state.currentHome != null)
    {
      newMarkers.remove(state.currentHome);
    }
    
    emit(state.copyWith(markers: newMarkers, currentHome: newMarker));
  }
  
  Future<void> moveCameraTo(double latitude, double longitude, {double zoomAmount = 1.0}) async
  {
    final GoogleMapController myController = await _controller.future;

    final LatLng newPosition = LatLng(latitude, longitude);

    final CameraPosition newCameraPosition = CameraPosition(target: newPosition, zoom: zoomAmount);

    myController.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  // Future<BitmapDescriptor> getRoomateIcon() async
  // {
  //   return await BitmapDescriptor.fromAssetImage(
  //     ImageConfiguration(devicePixelRatio: 2.5), 
  //     'assets/Roomate_Marker.png',
  //   );
  // }

}
