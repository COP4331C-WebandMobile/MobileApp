part of 'chores_cubit.dart';

@immutable


class ChoresState extends Equatable {

  //Different states
  Chore chores;


  const ChoresState({ //Initial state

    this.loading 

  })

  //Initial state is LoadingChores()


  //Copy with 

  LoadingChores();

  ChoresLoaded();

  ChoreList(){




  }



  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
  
  
  }
