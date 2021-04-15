import 'package:flutter/material.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';
import 'package:roomate_repository/roomate_repository.dart';
import 'package:roomiesMobile/utils/utility_functions.dart';

class ProfilePage extends StatelessWidget {
  final Roomate roomate;
  ProfilePage(this.roomate);

  static Route route(roomate) {
    return MaterialPageRoute(builder: (_) => ProfilePage(roomate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Roomies'),
        ),
        body: Container(
            child: Column(children: [
          HeaderBox(roomate),
          PhoneBox(roomate),
          EmailBox(roomate),
          ChoreBox(roomate),
          //MoneyBox(roomate),
        ])));
  }
}

class HeaderBox extends StatelessWidget {
  final Roomate roomate;
  HeaderBox(this.roomate);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: CustomColors.gold,
        ),
        child: Row(children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          Padding(padding: EdgeInsets.all(5)),
          Text(
            roomate.firstName + " ",
            textScaleFactor: 2,
          ),
          Text(
            roomate.lastName,
            textScaleFactor: 2,
          ),
        ]));
  }
}

class PhoneBox extends StatelessWidget {
  final Roomate roomate;
  PhoneBox(this.roomate);

  @override
  Widget build(BuildContext context) {
    print(roomate.phoneNumber);
    String phone = UtilityFunctions.formattedNumber(roomate.phoneNumber);
    return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
            color: CustomColors.gold,
            border: Border.all(
              color: Colors.black,
              width: 8,
            )),
        child: Row(children: [
          Icon(Icons.phone),
          Text("   " + phone),
        ]));
  }
}

class EmailBox extends StatelessWidget {
  final Roomate roomate;
  EmailBox(this.roomate);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
            color: CustomColors.gold,
            border: Border.all(
              color: Colors.black,
              width: 8,
            )),
        child: Row(children: [
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
    return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
            color: CustomColors.gold,
            border: Border.all(
              color: Colors.black,
              width: 8,
            )),
        child: Row(children: [
          Icon(Icons.flag),
          Text("   Chores Completed: " + roomate.totalChores.toString()),
        ]));
  }
}

class MoneyBox extends StatelessWidget {
  final Roomate roomate;
  MoneyBox(this.roomate);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: CustomColors.gold,
            border: Border.all(
              color: Colors.black,
              width: 8,
            )),
        child: Row(children: [
          CircleAvatar(),
          Text(roomate.firstName + " "),
          Text(roomate.lastName),
        ]));
  }
}
