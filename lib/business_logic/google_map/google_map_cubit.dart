import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'google_map_state.dart';

class GoogleMapCubit extends Cubit<GoogleMapState> 
{
  Completer<GoogleMapController> _controller = Completer();

  GoogleMapCubit() : super(GoogleMapInitial());


  Future<void> moveCameraTo(double latitude, double longitude) async
  {
    final GoogleMapController controller = await _controller.future;

    final LatLng newPosition = LatLng(latitude, longitude);

    final CameraPosition newCameraPosition = CameraPosition(target: newPosition);

    controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }


}
