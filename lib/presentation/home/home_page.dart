import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/roomates/cubit/roomates_cubit.dart';
import 'package:roomiesMobile/business_logic/reminders/cubit/reminders_cubit.dart';

import '../../business_logic/authentication/authentication.dart';
import '../../business_logic/authentication/bloc/authentication_bloc.dart';
import '../../widgets/home/sidebar.dart';
import '../../widgets/appbar.dart';
import 'package:reminder_repository/reminder_repository.dart';
import 'package:roomate_repository/roomate_repository.dart';



class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final _home = context.read<LandingCubit>().state.home;
    final _roomateRepository = RoomateRepository(_home);
    final _reminderRepository = ReminderRepository(_home);

    return Scaffold(
      appBar: Bar(),
      body: Container(
        child: Row(
        children:<Widget>[
          BlocProvider(
            create: (context)=> RoomatesCubit(roomateRepository: _roomateRepository),
            child: SizedBox(
              width:500,
              height:500,
              child:RoomateList(),
            )),
            BlocProvider(
            create: (context)=> ReminderCubit(reminderRepository: _reminderRepository),
            child: SizedBox(
              width:300,
              height:100,
              child:ReminderBox(),
            )
        )])),
      drawer: SideBar()
    );
  }
}
class RoomateList extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return BlocBuilder<RoomatesCubit,RoomatesState>(
  
      builder:(context,state){
      return Container(
        child:
        ListView.builder(
        itemCount: state.roomates.length,
        itemBuilder: (BuildContext context, i) {
        return RoomateIcon(state.roomates[i]);
        }
      ));});
  }
}
class RoomateIcon extends StatelessWidget{
  
  final Roomate roomate; 
  RoomateIcon(this.roomate);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CircleAvatar(
      child: TextButton(
        child: Text(roomate.firstName[0]),
        onPressed:() =>{},
    ));
  }
}

class ReminderText extends StatelessWidget{
  
  final Reminder reminder; 
  ReminderText(this.reminder);

  @override
 Widget build(BuildContext context){
  return Card(
    child: Column (
      children: [
        Text(reminder.description),
        Row(
        children: <Widget>[ElevatedButton(
          onPressed: () {
            //context.read<RemindersBloc>().add(CompleteChore(chore));
            },
          child: Text("Completed")
        ),
        ElevatedButton(
          onPressed: () { 
          //context.read<ChoresBloc>().add(DeleteChore(chore));
          },
          child: Text("Delete"),
        ),
        ElevatedButton(
          onPressed: () { 
            // context.read<ChoresBloc>().add(MarkChore(chore));
           },
          child: Text("Mark")
        )]),
    ],)
   );


}
}

class ReminderBox extends StatelessWidget {
  
  @override 
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderCubit,ReminderState>(
      builder:(context,state){
      return Container(
        child:
        ListView.builder(
        itemCount: state.reminders.length,
        itemBuilder: (BuildContext context, i) {
        return ReminderText(state.reminders[i]);
        }
      ));});
  }
}

/*
class Reminders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
*/