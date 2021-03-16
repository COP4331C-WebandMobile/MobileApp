import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chores_event.dart';
part 'chores_state.dart';

class ChoresBloc extends Bloc<ChoresEvent, ChoresState> {
  ChoresBloc() : super(ChoresInitial());

  @override
  Stream<ChoresState> mapEventToState(
    ChoresEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
