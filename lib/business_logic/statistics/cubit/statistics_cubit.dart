import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'statistics_state.dart';

class StatsCubit extends Cubit<StatsState> {
 

  final FirebaseFirestore _fireStore;
  final _home;
  final email;

    StatsCubit(this._home,this.email) : this._fireStore = FirebaseFirestore.instance, super(StatsState.loading()){
      getStats();
    }
  

  Future<void> getStats() async {

       

       emit(StatsState.loading());
       
       List<Stat> stats = [];

       await _fireStore
        .collection("roomates")
        .doc(_home)
        .collection('roomates')
        .doc(email)
        .collection("chores").get().then((value) => value.docs.forEach((element) {
          var description = element.data()["description"];
          var completed= element.data()["completed"];
          print(description);

          stats.add(Stat(description,completed));
          
        }));

        print("Testimgfdgf");

        print(stats[0].completed);


        emit(StatsState.loaded(stats));


  }   
}