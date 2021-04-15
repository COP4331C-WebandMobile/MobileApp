part of 'statistics_cubit.dart';


enum StatStatus {Loading,Loaded}

class Stat{
  final description;
  final completed;
  Stat(this.description,this.completed);
}

class StatsState extends Equatable {

  final status; 
  final List<Stat> stats;

  @override
  List<Object> get props => [status];

  StatsState._({
  this.status = StatStatus.Loading,
  this.stats,
  });


  StatsState.loading() : this._();

  StatsState.loaded(stats) : this._(status: StatStatus.Loaded,stats:stats);


}
