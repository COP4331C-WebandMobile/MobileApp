import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/roomates/cubit/roomates_cubit.dart';
import 'package:roomiesMobile/business_logic/reminders/cubit/reminders_cubit.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';

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
    MediaQueryData mediaQuery = MediaQuery.of(context);

    

    return Scaffold(
      appBar: Bar(),
      body: Container(
        padding: EdgeInsets.all(32),
        height: mediaQuery.size.height,
        width: mediaQuery.size.width,
        child: Column(
        children:<Widget>[
            Expanded(
            flex:3,
            child: HouseInfo(),
            ),

          Expanded(
            flex:2,
            child:BlocProvider(
            create: (context)=> RoomatesCubit(roomateRepository: _roomateRepository),
              child:RoomateList(),
            )),
          
            Expanded(
            flex:8,
            child:BlocProvider(
              create: (context)=> ReminderCubit(reminderRepository: _reminderRepository),
              child:ReminderBox(),
            )),
        ])),
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
        margin: EdgeInsets.all(10),
        color: CustomColors.gold,
        child: Column(
          children:[
            
          Expanded(
            flex:1,
            child: Row(
              children: [
              Align(
                alignment: Alignment.topLeft,
                child:Text("Add")),
                
              Align( 
                alignment: Alignment.topRight,
                child:IconButton(
                icon: const Icon(Icons.add_circle_outline_outlined),
                onPressed: () => {},
                ))
            
              ])),
          Expanded(
          flex: 4,
          child: Container(     
           
            child:ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.roomates.length,
              itemBuilder: (BuildContext context, i) {
              return RoomateIcon(state.roomates[i]);
            }
      )
      )
      )
      ]
      )
      )
      ;
      }
      )
      ;
  }
}



class HouseInfo extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child:Column(
        children: [

          CircleAvatar(),
          Text("Address")
        ],
        )
    );
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
  return  Card(
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

        Text("Frequency")
     ]),
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
        color: CustomColors.gold,
        padding: EdgeInsets.all(22),
        margin: EdgeInsets.all(10),
        child : Column(
          children : <Widget>[
          Expanded(
          flex:2,
          child: Row(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child:Text("Reminders")),
              Align(
                alignment: Alignment.topRight,
                child:IconButton(
                icon: const Icon(Icons.add_circle_outline_outlined),
                onPressed: () => {},
              ))
            ],
          )),
          Expanded(
            flex:8,
              child:
                ListView.builder(
                itemCount: state.reminders.length,
                itemBuilder: (BuildContext context, i) {
                return ReminderText(state.reminders[i]);
                }
              )
            )
          ]));
        }
      );
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