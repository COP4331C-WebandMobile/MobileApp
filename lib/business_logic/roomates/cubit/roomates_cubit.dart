import 'dart:async';
import 'package:roomate_repository/roomate_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'roomates_state.dart';

class RoomatesCubit extends Cubit<RoomatesState> {

   StreamSubscription _roomatesSubscription;
   final _roomateRepository;

    RoomatesCubit({
    @required RoomateRepository roomateRepository,
  })  :   assert(roomateRepository != null),
         _roomateRepository = roomateRepository,
         super( RoomatesState.loading()){
            roomates();
         }
  void roomates() {
    _roomatesSubscription = _roomateRepository.roomates().listen(
    (roomates) => emit(RoomatesState.loaded(roomates)));
  }
    Future<void> AddRoomate(email){
    _roomateRepository.addRoomate(email);
  }

  @override
  Future<void> close() {
      _roomatesSubscription.cancel();
      return super.close();
    }
}
