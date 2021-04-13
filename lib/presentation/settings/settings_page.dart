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
    var email = context.read<AuthenticationBloc>().state.user.email;
    var home = context.read<LandingCubit>().state.home;
    SettingsRepository _settingsRepository = SettingsRepository(home, email);

    return Scaffold(
        appBar: Bar(),
        body: BlocProvider(
            create: (context) =>
                SettingsCubit(settingsRepository: _settingsRepository),
            child: Container(
                height: mediaQuery.size.height,
                width: mediaQuery.size.width,
                child: BlocConsumer<SettingsCubit, SettingsState>(
                  listener: (context, state) {
                    
                  },
                    builder: (context, state) {
                  return ListView(children: [
                    HeaderBox(),
                    FirstName(),
                    LastName(),
                    PhoneNumber(),
                    EmailBox(),
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) =>
                                        BlocProvider<SettingsCubit>.value(
                                            value:
                                                BlocProvider.of<SettingsCubit>(
                                                    context),
                                            child: LeaveHome()));
                              },
                              child: Text("Leave Home"),
                            )),
                        Container(
                            margin: EdgeInsets.all(10),
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) =>
                                        BlocProvider<SettingsCubit>.value(
                                            value:
                                                BlocProvider.of<SettingsCubit>(
                                                    context),
                                            child: DeleteAccount()));
                              },
                              child: Text("Delete Account"),
                            )),
                        Container(
                            margin: EdgeInsets.all(10),
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) =>
                                        BlocProvider<SettingsCubit>.value(
                                            value:
                                                BlocProvider.of<SettingsCubit>(
                                                    context),
                                            child: ChangePassword()));
                              },
                              child: Text("Change Password"),
                            )),
                      ],
                    )

                    //ChoreBox(roomate),
                    //MoneyBox(roomate),
                  ]);
                }))));
  }
}
class HeaderBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firstName = context.read<SettingsCubit>().state.user.firstName;
    final lastName = context.read<SettingsCubit>().state.user.lastName;

    return Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: CustomColors.gold,
        ),
        child: Row(children: [
          Container(
              margin: EdgeInsets.all(10),
              child: CircleAvatar(
                child: Icon(
                  Icons.people,
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
              )),

          Text(
            firstName + " ",
            textScaleFactor: 2,
          ),
          Text(
            lastName + " ",
            textScaleFactor: 2,
          ),
          // Text(roomate.lastName),
        ]));
  }
}

class FirstName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firstName = context.read<SettingsCubit>().state.user.firstName;

    final firstNameController = TextEditingController();

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ExpansionTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: Text('First'),
          ),
          title: Text(firstName),
          children: <Widget>[
            TextField(
              
              controller: firstNameController,
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                context
                    .read<SettingsCubit>()
                    .changeFirstName(firstNameController.text);
              },
            )
          ],
        ));
  }
}

class LastName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lastName = context.read<SettingsCubit>().state.user.lastName;

    final lastNameController = TextEditingController();

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ExpansionTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: Text('Last'),
          ),
          title: Text(lastName),
          children: <Widget>[
            TextField(
              controller: lastNameController,
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                context
                    .read<SettingsCubit>()
                    .changeLastName(lastNameController.text);
              },
            )
          ],
        ));
  }
}

class PhoneNumber extends StatelessWidget {

  String formatPhoneNumber(String phoneNumber)
  {
    if(phoneNumber == '')
    {  
      return '';
    }

    // Can't format an invalid phone number
    if(phoneNumber.length < 10)
    {
      return phoneNumber;
    }

    String formattedNumber = '';
    int count = 0;

    for(int i = 0; i < phoneNumber.length; i++)
    {
      if(i % 3 == 0 && i != 0 && count < 2)
      {
        formattedNumber += '-';
        count++;
      }

      formattedNumber += phoneNumber[i];
    }

    return formattedNumber;
  }

  @override
  Widget build(BuildContext context) {
    final rawPhoneNumber = context.read<SettingsCubit>().state.user.phoneNumber;
    final formattedPhoneNumber = formatPhoneNumber(rawPhoneNumber);
    final phoneNumberController = TextEditingController();

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ExpansionTile(
          childrenPadding: EdgeInsets.all(16),
          leading: const CircleAvatar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: const Icon(Icons.phone),
          ),
          title: Text(formattedPhoneNumber),
          children: <Widget>[
 
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  contentPadding: EdgeInsets.all(10),
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      radius: 10,
                      child: IconButton (
                        iconSize: 16,
                                  icon: Icon(Icons.check),
                                  onPressed: () {
                                    context
                        .read<SettingsCubit>()
                        .changePhoneNumber(phoneNumberController.text);
                                  },
                                )
                    )
                  )
                ),
                keyboardType: TextInputType.phone,
                controller: phoneNumberController,
              ),
            
          ],
        ));
  }
}

class EmailBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final email = context.read<SettingsCubit>().state.user.email;
    final emailController = TextEditingController();

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ExpansionTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: const Icon(Icons.mail),
          ),
          title: Text(email),
          children: <Widget>[
            TextField(
              controller: emailController,
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                context
                    .read<AuthenticationBloc>()
                    .changeEmail(emailController.text);
              },
            )
          ],
        ));
  }
}

class ChoreBox extends StatelessWidget {
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
          //Text(roomate.firstName + " "),
          // Text(roomate.lastName),
        ]));
  }
}

class MoneyBox extends StatelessWidget {
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
          // Text(roomate.firstName + " "),
          //Text(roomate.lastName),
        ]));
  }
}

class LeaveHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
            child: Column(
      children: [
        Text("Are You Sure you Want to leave this home"),
        ElevatedButton(
            child: Text("Delete"),
            onPressed: () {
              context.read<SettingsCubit>().leaveHome();
            })
      ],
    )));
  }
}

class DeleteAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
            child: Column(
      children: [
        Text("Are you sure you want to delete you account"),
        ElevatedButton(
            child: Text("Delete"),
            onPressed: () {
              context.read<AuthenticationBloc>().deleteAccount();
            })
      ],
    )));
  }
}

class ChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final password = TextEditingController();
    final confirmPassword = TextEditingController();
    return Dialog(
        child: Container(
            child: Column(
      children: [
        Text("New Password"),
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            labelText: 'Content',
            helperText: '',
            hintText: 'Turn Of Lights!',
          ),
          controller: password,
        ),
        Text("Confirm Password"),
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            labelText: 'Content',
            helperText: '',
            hintText: 'Turn Of Lights!',
          ),
          controller: confirmPassword,
        ),
        ElevatedButton(
            child: Text("Delete"),
            onPressed: () {
              context
                  .read<AuthenticationBloc>()
                  .changePassword(confirmPassword.text);
            })
      ],
    )));
  }
}
