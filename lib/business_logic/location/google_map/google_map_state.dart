part of 'google_map_cubit.dart';

class GoogleMapState extends Equatable {

  final List<Marker> markers;
  final Marker currentHome;

  const GoogleMapState({this.markers = const [], this.currentHome});

  GoogleMapState copyWith({
    List<Marker> markers,
    Marker currentHome,
  })
  {
    return GoogleMapState(markers: markers ?? this.markers, currentHome: currentHome ?? this.currentHome);
  }

  @override
  List<Object> get props => [markers, currentHome];
}


