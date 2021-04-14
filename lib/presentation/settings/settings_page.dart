import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/authentication/bloc/authentication_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/settings/cubit/settings_cubit.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';
import 'package:roomiesMobile/widgets/appbar.dart';
import 'package:settings_repository/settings_repository.dart';

typedef VoidCallBack = Function(void);

class SettingsPage extends StatelessWidget {

  SettingsPage();


  static Route route(roomate) {
    return MaterialPageRoute(builder: (_) => SettingsPage());
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    final email = context.read<AuthenticationBloc>().state.user.email;
    final home = context.read<LandingCubit>().state.home;
    SettingsRepository _settingsRepository = SettingsRepository(home, email);

    return Scaffold(
        appBar: Bar(),
        body: BlocProvider<SettingsCubit>(
            create: (context) =>
                SettingsCubit(settingsRepository: _settingsRepository),
            child: BlocBuilder<SettingsCubit, SettingsState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
              return
            Container(
                height: mediaQuery.size.height,
                width: mediaQuery.size.width,
                child:
                      ListView(children: [
                        HeaderBox(),
                        FirstName(),
                        LastName(),
                        _PhoneNumber(),
                        _EmailBox(),
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 30),
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                            BlocProvider<SettingsCubit>.value(
                                                value: BlocProvider.of<
                                                    SettingsCubit>(context),
                                                child: LeaveHome()));
                                  },
                                  child: Text("Leave Home"),
                                )),
                            Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                            BlocProvider<SettingsCubit>.value(
                                                value: BlocProvider.of<
                                                    SettingsCubit>(context),
                                                child: DeleteAccount()));
                                  },
                                  child: Text("Delete Account"),
                                )),
                            Container(
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
                        ) ,                    //ChoreBox(roomate),                      //MoneyBox(roomate),
                      ]),
                    );})));
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
    return BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) => previous.first != current.first,
        builder: (context, state) {
          print(state.first.valid);
          return Card(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: ExpansionTile(
                childrenPadding: EdgeInsets.all(16),
                leading: const CircleAvatar(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  child: Text('First'),
                ),
                title: Text(state.user.firstName),
                children: <Widget>[
                  TextField(
                    onChanged: (value) =>
                        context.read<SettingsCubit>().onFirstNameChanged(value),
                    decoration: InputDecoration(
                        hintText: 'Jane',
                        errorText: state.first.invalid ? 'Invalid Name' : null,
                        border: OutlineInputBorder(),
                        filled: true,
                        contentPadding: EdgeInsets.all(10),
                        suffixIcon: SubmitButton(
                          visible: (state.first.valid),
                          onPressed: () {
                            context.read<SettingsCubit>().changeFirstName(state.first.value);
                          },
                        ),
                        
                              ),
                  ),
                ],
              ));
        });
  }
}


class SubmitButton extends StatelessWidget {

  final visible;
  final onPressed;

  SubmitButton({this.visible, this.onPressed = VoidCallBack});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity( 
                            opacity: visible ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 500),
                            child:
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    radius: 10,
                                    child: visible ?
                                    IconButton(
                                      iconSize: 16,
                                      icon: Icon(Icons.check),
                                      onPressed: onPressed
                                    ): null)));
  }



}


class LastName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) => previous.last != current.last,
        builder: (context, state) {
          return Card(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: ExpansionTile(
                childrenPadding: EdgeInsets.all(16),
                leading: const CircleAvatar(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  child: Text('Last'),
                ),
                title: Text(state.user.lastName),
                children: <Widget>[
                  TextField(
                    onChanged: (value) =>
                        context.read<SettingsCubit>().onLastNameChanged(value),
                    decoration: InputDecoration(
                        hintText: 'Doe',
                        errorText: state.last.invalid ? 'Invalid Name' : null,
                        border: OutlineInputBorder(),
                        filled: true,
                        contentPadding: EdgeInsets.all(10),
                        suffixIcon: SubmitButton(
                          visible: (state.last.valid),
                          onPressed: () {
                            context.read<SettingsCubit>().changeLastName(state.last.value);
                          },
                        ),
                  )),
                ],
              ));
        });
  }
}

class _PhoneNumber extends StatelessWidget {
  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber == '') {
      return '';
    }

    // Can't format an invalid phone number
    if (phoneNumber.length < 10) {
      return phoneNumber;
    }

    String formattedNumber = '';
    int count = 0;

    for (int i = 0; i < phoneNumber.length; i++) {
      if (i % 3 == 0 && i != 0 && count < 2) {
        formattedNumber += '-';
        count++;
      }

      formattedNumber += phoneNumber[i];
    }

    return formattedNumber;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.phoneNumber != current.phoneNumber,
        builder: (context, state) {
          return Card(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: ExpansionTile(
                childrenPadding: EdgeInsets.all(16),
                leading: const CircleAvatar(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.phone),
                ),
                title: Text(formatPhoneNumber(state.user.phoneNumber)),
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    onChanged: (phoneNumber) => context
                        .read<SettingsCubit>()
                        .onPhoneNumberChanged(phoneNumber),
                    decoration: InputDecoration(
                        hintText: '4078589944',
                        helperText: 'Only use numbers...',
                        errorText: state.phoneNumber.invalid
                            ? 'Invalid only use Numbers'
                            : null,
                        border: OutlineInputBorder(),
                        filled: true,
                        contentPadding: EdgeInsets.all(10),
                        suffixIcon: SubmitButton(
                          visible: state.phoneNumber.valid,
                          onPressed: () {
                            context.read<SettingsCubit>().changePhoneNumber(state.phoneNumber.value);
                          },
                        )
                        ),
                    keyboardType: TextInputType.phone,

                  ),
                ],
              ));
        });
  }
}

class _EmailBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return Card(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: ExpansionTile(
                childrenPadding: EdgeInsets.all(16),
                leading: const CircleAvatar(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.mail),
                ),
                title: Text(state.user.email),
                children: <Widget>[
                  TextField(
                    onChanged: (value) =>
                        context.read<SettingsCubit>().onEmailChanged(value),
                    decoration: InputDecoration(
                        hintText: 'johnDoe@gmail.com',
                        errorText:
                            state.email.invalid ? 'Invalid Email Format' : null,
                        border: OutlineInputBorder(),
                        filled: true,
                        contentPadding: EdgeInsets.all(10),
                        suffixIcon: SubmitButton(
                          visible: state.email.valid,
                          onPressed: () {context.read<AuthenticationBloc>().changeEmail(state.email.value);},
                        ),
                  ),
                  )],
              ));
        });
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
