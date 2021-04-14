part of 'google_map_cubit.dart';

class GoogleMapState extends Equatable {

  final List<Marker> markers;
  const GoogleMapState({this.markers = const []});

  GoogleMapState copyWith({
    List<Marker> markers
  })
  {
    return GoogleMapState(markers: markers ?? this.markers);
  }

  @override
  List<Object> get props => [markers];
}


