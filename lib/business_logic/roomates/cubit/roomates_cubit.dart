import 'dart:async';
import 'package:roomate_repository/roomate_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'roomates_state.dart';

class RoomatesCubit extends Cubit<RoomatesState> {

   StreamSubscription _roomateSubscription;
   final _roomateRepository;

    RoomatesCubit({
    @required RoomateRepository roomateRepository,
  })  :   assert(roomateRepository != null),
         _roomateRepository = roomateRepository,
         super( RoomatesState([Roomate("Testing","Testing","Testing","Testing","Tesitng")],status.loading)){
            roomates();
         }
  void roomates() {
    _roomateSubscription = _roomateRepository.roomates().listen(
    (roomates) => emit(RoomatesState(roomates,status.loaded)));
  }

  @override
  Future<void> close() {
      _roomateSubscription.cancel();
      return super.close();
    }
}
