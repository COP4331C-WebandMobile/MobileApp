import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/roomates/cubit/roomates_cubit.dart';
import 'package:roomiesMobile/business_logic/reminders/cubit/reminders_cubit.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';
import 'package:roomiesMobile/widgets/appbar.dart';
import '../../widgets/home/sidebar.dart';
import 'package:reminder_repository/reminder_repository.dart';
import 'package:roomate_repository/roomate_repository.dart';


class ProfilePage extends StatelessWidget {

  final Roomate roomate;
  ProfilePage(this.roomate);


  static Route route(roomate) {
    return MaterialPageRoute(builder: (_) => ProfilePage(roomate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(),
      body: Container(


        child: Column(
        children: [
         
          HeaderBox(roomate),
          PhoneBox(roomate),
          EmailBox(roomate),
          //ChoreBox(roomate),
          //MoneyBox(roomate),

        ])));

  }

  
}


  



class HeaderBox extends StatelessWidget {

  final Roomate roomate;
  HeaderBox(this.roomate);

  @override
  Widget build(BuildContext context) {
  
      return  Container(
             
              padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
              color: CustomColors.gold,
              
              ),
              child: Row(

              children: [
                CircleAvatar(),
                Text(roomate.firstName + " "),
                Text(roomate.lastName),
            ]));
            
  }

}

class PhoneBox extends StatelessWidget {

  final Roomate roomate;
  PhoneBox(this.roomate);
  @override
  Widget build(BuildContext context) {
  
      return  Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
              color: CustomColors.gold,
              border: Border.all(
              color: Colors.black,
              width: 8,
              )),
              child: Row(
              children: [
                Icon(Icons.phone),
                Text("   " + roomate.phoneNumber),
                
            ]));
            
  }

}


class EmailBox extends StatelessWidget {

  final Roomate roomate;
  EmailBox(this.roomate);
  @override
  Widget build(BuildContext context) {
  
      return  Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
              color: CustomColors.gold,
              border: Border.all(
              color: Colors.black,
              width: 8,
              )),
              child: Row(

              children: [
                Icon(Icons.email),
                Text("   " + roomate.email),
              ]));
            
  }

}

class ChoreBox extends StatelessWidget {

  final Roomate roomate;
  ChoreBox(this.roomate);
  @override
  Widget build(BuildContext context) {
  
      return  Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
              color: CustomColors.gold,
              border: Border.all(
              color: Colors.black,
              width: 8,
              )),
              child: Row(

              children: [
                CircleAvatar(),
                Text(roomate.firstName + " "),
                Text(roomate.lastName),
            ]));
            
  }

}


class MoneyBox extends StatelessWidget {

  final Roomate roomate;
  MoneyBox(this.roomate);
  @override
  Widget build(BuildContext context) {
  
      return  Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
              color: CustomColors.gold,
              border: Border.all(
              color: Colors.black,
              width: 8,
              )),
              child: Row(

              children: [
                CircleAvatar(),
                Text(roomate.firstName + " "),
                Text(roomate.lastName),
            ]));
            
  }

}
