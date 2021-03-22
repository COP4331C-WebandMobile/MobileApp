part of 'chores_bloc.dart';

@immutable
abstract class ChoresEvent extends Equatable {
  const ChoresEvent();

  @override
  List<Object> get props => [];
}

class LoadChores extends ChoresEvent {}

class AddChore extends ChoresEvent {
  final Chore chore;

  const AddChore(this.chore);

  @override
  List<Object> get props => [chore];

  @override
  String toString() => 'AddChore { Chore: $Chore }';
}

class UpdateChore extends ChoresEvent {
  final Chore updatedChore;

  const UpdateChore(this.updatedChore);

  @override
  List<Object> get props => [updatedChore];

  @override
  String toString() => 'UpdateChore { updatedChore: $updatedChore }';
}

class DeleteChore extends ChoresEvent {
  final Chore chore;

  const DeleteChore(this.chore);

  @override
  List<Object> get props => [Chore];

  @override
  String toString() => 'DeleteChore { Chore: $Chore }';
}

class ChoresUpdated extends ChoresEvent {
  final List<Chore> chores;

  const ChoresUpdated(this.chores);

  @override
  List<Object> get props => [chores];
}