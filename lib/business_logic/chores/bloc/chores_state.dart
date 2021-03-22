part of 'chores_bloc.dart';

@immutable
abstract class ChoresState extends Equatable {
  const ChoresState();

  @override
  List<Object> get props => [];
}

class ChoresLoading extends ChoresState {}

class ChoresLoaded extends ChoresState {
  final List<Chore> Chores;

  const ChoresLoaded([this.Chores = const []]);

  @override
  List<Object> get props => [Chores];

  @override
  String toString() => 'ChoresLoaded { Chores: $Chores }';
}

class ChoresNotLoaded extends ChoresState {}