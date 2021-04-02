import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/authentication/bloc/authentication_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/roomates/cubit/roomates_cubit.dart';
import 'package:roomiesMobile/business_logic/reminders/cubit/reminders_cubit.dart';
import 'package:roomiesMobile/business_logic/settings/cubit/settings_cubit.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';
import 'package:roomiesMobile/widgets/appbar.dart';
import '../../widgets/home/sidebar.dart';
import 'package:settings_repository/settings_repository.dart';



class SettingsPage extends StatelessWidget {


  SettingsPage();


  static Route route(roomate) {
    return MaterialPageRoute(builder: (_) => SettingsPage());
  }

  @override
  Widget build(BuildContext context) {

    MediaQueryData mediaQuery = MediaQuery.of(context);
    SettingsRepository _settingsRepository = SettingsRepository(context.read<AuthenticationBloc>().state.user.email);

    return Scaffold(
      appBar: Bar(),
      body:  BlocProvider(
              create: (context) =>
              SettingsCubit(settingsRepository: _settingsRepository),
              child: Container(
        height: mediaQuery.size.height,
        width: mediaQuery.size.width,
        child:  BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
        return Column(  
          children: [
    
          HeaderBox(),
          PhoneBox(),
          EmailBox(),
          
          //ChoreBox(roomate),
          //MoneyBox(roomate),
        ]);}
        ))));

  }
 
}
class HeaderBox extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    final firstName = context.read<SettingsCubit>().state.user.firstName;
    final lastName = context.read<SettingsCubit>().state.user.firstName;
  
      return  Container(    
              padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
              color: CustomColors.gold,
              
              ),
              child: Row(
              children: [
                CircleAvatar(),
                
                Text(firstName + " "),
                Text(lastName + " "),
               // Text(roomate.lastName),
            ]));
            
  }

}
class PhoneBox extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {

    final phoneNumber = context.read<SettingsCubit>().state.user.firstName;

  
      return  Card(
              margin: EdgeInsets.all(20),
              child:  ExpansionTile(
                title:Text(phoneNumber),
                children: <Widget>[
                TextField(),
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: (){
                  },
                )
                ],
              ));     
  }
}

class EmailBox extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

      final email = context.read<SettingsCubit>().state.user.email;
      final emailController = TextEditingController();


      return  Card(
              margin: EdgeInsets.all(20),
              child:  ExpansionTile(
                title: Text(email),
                children: <Widget>[
                TextField(
                  controller: emailController,
                ),
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: (){
                   context.read<AuthenticationBloc>().changeEmail(emailController.text);
                  },
                )
                ],
              ));         
  }

}

class ChoreBox extends StatelessWidget {


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
                //Text(roomate.firstName + " "),
               // Text(roomate.lastName),
            ]));
            
  }

}


class MoneyBox extends StatelessWidget {


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
               // Text(roomate.firstName + " "),
                //Text(roomate.lastName),
            ]));
            
  }

}
 


