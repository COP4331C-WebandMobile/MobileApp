part of 'roomates_cubit.dart';

enum RoomateStatus {Loaded, Loading}

class RoomatesState extends Equatable {

  final List<Roomate> roomates;
  final status; 

  const RoomatesState._({
    this.status,
    this.roomates,
    
    });
  @override
  List<Object> get props => [roomates, status];

  const RoomatesState.loaded(roomates) : this._(status: RoomateStatus.Loaded,roomates:roomates);
  const RoomatesState.loading() : this._(status: RoomateStatus.Loading);


}

//const LandingState.loading() : this._();

//const LandingState.homeVerified(String home) : this._(status: HomeStatus.HomeVerified, home: home);

//const LandingState.homeless() : this._(status: HomeStatus.Homeless);