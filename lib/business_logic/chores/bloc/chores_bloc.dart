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
        super(ChoresLoading()) {
    _choresSubscription = _choresRepository
        .chores()
        .listen((chores) => add(ChoresUpdated(chores)));
  }

  @override
  Stream<ChoresState> mapEventToState(ChoresEvent event) async* {
    if (event is AddChore) {
      yield* _mapAddChoreToState(event);
    } else if (event is UpdateChore) {
      yield* _mapUpdateChoreToState(event);
    } else if (event is DeleteChore) {
      yield* _mapDeleteChoreToState(event);
    } else if (event is ChoresUpdated) {
      yield* _mapChoresUpdateToState(event);
    } else if (event is MarkChore) {
      yield* _mapMarkChoreToState(event);
    } else if (event is UnMarkChore) {
      yield* _mapUnMarkChoreToState(event);
    } else if (event is CompleteChore) {
      yield* _mapCompleteChoreToState(event);
    }
  }

  Stream<ChoresState> _mapUnMarkChoreToState(UnMarkChore event) async* {
    _choresRepository.unmarkChore(event.chore);
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

  Stream<ChoresState> _mapMarkChoreToState(MarkChore event) async* {
    _choresRepository.markChore(event.chore);
  }

  Stream<ChoresState> _mapChoresUpdateToState(ChoresUpdated event) async* {
    yield ChoresLoaded(event.chores);
  }

  Stream<ChoresState> _mapCompleteChoreToState(CompleteChore event) async* {
    _choresRepository.completeChore(event.chore, event.email);
  }

  @override
  Future<void> close() {
    _choresSubscription?.cancel();
    return super.close();
  }
}
