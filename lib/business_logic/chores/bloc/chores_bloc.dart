import 'dart:async';

import 'package:chore_repository/chore_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'chores_event.dart';
part 'chores_state.dart';


class ChoresBloc extends Bloc<ChoresEvent, ChoresState> {
  final ChoresRepository _ChoresRepository;
  StreamSubscription _ChoresSubscription;

  ChoresBloc({@required ChoresRepository ChoresRepository})
      : assert(ChoresRepository != null),
        _ChoresRepository = ChoresRepository,
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
    _ChoresSubscription?.cancel();
    _ChoresSubscription = _ChoresRepository.Chores().listen(
          (Chores) => add(ChoresUpdated(Chores)), //
        );
  }

  Stream<ChoresState> _mapAddChoreToState(AddChore event) async* {
    _ChoresRepository.addNewChore(event.Chore);
  }

  Stream<ChoresState> _mapUpdateChoreToState(UpdateChore event) async* {
    _ChoresRepository.updateChore(event.updatedChore);
  }

  Stream<ChoresState> _mapDeleteChoreToState(DeleteChore event) async* {
    _ChoresRepository.deleteChore(event.Chore);
  }

  Stream<ChoresState> _mapChoresUpdateToState(ChoresUpdated event) async* {
    yield ChoresLoaded(event.Chores);
  }

  @override
  Future<void> close() {
    _ChoresSubscription?.cancel();
    return super.close();
  }
}
