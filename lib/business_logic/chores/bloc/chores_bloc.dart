import 'dart:async';

import 'package:chore_repository/chore_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'chores_event.dart';
part 'chores_state.dart';


class ChoresBloc extends Bloc<ChoresEvent, ChoresState> {
  final ChoresRepository _choresRepository;
  StreamSubscription _choresSubscription;

  ChoresBloc({@required ChoresRepository choresRepository})
      : assert(choresRepository != null),
        _choresRepository = choresRepository,
        super(ChoresLoading());

  @override
  Stream<ChoresState> mapEventToState(ChoresEvent event) async* {
    if (event is LoadChores) {
      yield* _mapLoadChoresToState();
    } else if (event is AddChore) {
      yield* _mapAddChoreToState(event);
    } else if (event is UpdateChore) {
      yield* _mapUpdateChoreToState(event);
    } else if (event is DeleteChore) {
      yield* _mapDeleteChoreToState(event);
    } else if (event is ChoresUpdated) {
      yield* _mapChoresUpdateToState(event);
    }
  }

  Stream<ChoresState> _mapLoadChoresToState() async* {
    _choresSubscription?.cancel();
    _choresSubscription = _choresRepository.chores().listen(
          (chores) => add(ChoresUpdated(chores)), //
        );
  }

  Stream<ChoresState> _mapAddChoreToState(AddChore event) async* {
    _choresRepository.addNewChore(event.chore);
  }

  Stream<ChoresState> _mapUpdateChoreToState(UpdateChore event) async* {
    _choresRepository.updateChore(event.updatedChore);
  }

  Stream<ChoresState> _mapDeleteChoreToState(DeleteChore event) async* {
    _choresRepository.deleteChore(event.chore);
  }

  Stream<ChoresState> _mapChoresUpdateToState(ChoresUpdated event) async* {
    yield ChoresLoaded(event.chores);
  }

  @override
  Future<void> close() {
    _choresSubscription?.cancel();
    return super.close();
  }
}