part of 'chores_bloc.dart';

//enum status {ChoresLoaded,ToDo}

@immutable
abstract class ChoresState extends Equatable {
  const ChoresState();
  @override
  List<Chore> get props => [];
}

class ChoresLoading extends ChoresState {}

class ChoresLoaded extends ChoresState {
  final List<Chore> chores;

  const ChoresLoaded([this.chores = const []]);

  @override
  List<Chore> get props => chores;

  @override
  String toString() => 'ChoresLoaded { Chores: $chores }';
}

class ChoresNotLoaded extends ChoresState {}