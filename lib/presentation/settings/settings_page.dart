import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/authentication/bloc/authentication_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/location/address_location/address_location_bloc.dart';
import 'package:roomiesMobile/business_logic/settings/cubit/settings_cubit.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';
import 'package:roomiesMobile/utils/utility_functions.dart';
import 'package:roomiesMobile/widgets/ConfirmationDialog.dart';
import 'package:roomiesMobile/widgets/home/new_sidebar.dart';

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
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text('Settings'),
            actions: <Widget>[]),
        body: BlocProvider<SettingsCubit>(
            create: (context) =>
                SettingsCubit(settingsRepository: _settingsRepository),
            child: BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  return Container(
                    height: mediaQuery.size.height,
                    width: mediaQuery.size.width,
                    child: ListView(children: [
                      HeaderBox(),
                      _FirstName(),
                      _LastName(),
                      _PhoneNumber(),
                      // _EmailBox(),
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
                                              child: ConfirmationDialog(
                                                title: Text('Confirmation'),
                                                snippet: Text(
                                                  'Are you sure you want to leave the \'$home\' home?',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onConfirm: () {
                                                  try {
                                                    context
                                                        .read<SettingsCubit>()
                                                        .leaveHome();

                                                    Navigator.pop(context);
                                                  } on Exception {}
                                                },
                                              )));
                                },
                                child: Text("Leave Home"),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => BlocProvider<
                                              SettingsCubit>.value(
                                          value: BlocProvider.of<SettingsCubit>(
                                              context),
                                          child: ConfirmationDialog(
                                              snippet: const Text(
                                                'Are you sure you want to delete your account?',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onConfirm: () {
                                                context
                                                    .read<AuthenticationBloc>()
                                                    .deleteAccount(home);
                                              })));
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
                                          value: BlocProvider.of<SettingsCubit>(
                                              context),
                                          child: ChangePassword()));
                            },
                            child: Text("Change Password"),
                          )),
                        ],
                      ),
              
                    ])
                    ,
                  );
                })),
        drawer: NewSideBar());
  }
}


// TODO: For some reason this page ends up accessing null on entering page.
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

class _FirstName extends StatelessWidget {
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
                      suffixIcon: _SubmitButton(
                        visible: (state.first.valid),
                        onPressed: () {
                          context
                              .read<SettingsCubit>()
                              .changeFirstName(state.first.value);
                        },
                      ),
                    ),
                  ),
                ],
              ));
        });
  }
}

class _SubmitButton extends StatelessWidget {
  final visible;
  final onPressed;

  _SubmitButton({this.visible, this.onPressed = VoidCallBack});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: CircleAvatar(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                radius: 10,
                child: visible
                    ? IconButton(
                        iconSize: 16,
                        icon: Icon(Icons.check),
                        onPressed: onPressed)
                    : null)));
  }
}

class _LastName extends StatelessWidget {
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
                      onChanged: (value) => context
                          .read<SettingsCubit>()
                          .onLastNameChanged(value),
                      decoration: InputDecoration(
                        hintText: 'Doe',
                        errorText: state.last.invalid ? 'Invalid Name' : null,
                        border: OutlineInputBorder(),
                        filled: true,
                        contentPadding: EdgeInsets.all(10),
                        suffixIcon: _SubmitButton(
                          visible: (state.last.valid),
                          onPressed: () {
                            context
                                .read<SettingsCubit>()
                                .changeLastName(state.last.value);
                          },
                        ),
                      )),
                ],
              ));
        });
  }
}

class _PhoneNumber extends StatelessWidget {
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
                title:
                    Text(UtilityFunctions.formatNumber(state.user.phoneNumber)),
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
                        suffixIcon: _SubmitButton(
                          visible: state.phoneNumber.valid,
                          onPressed: () {
                            context
                                .read<SettingsCubit>()
                                .changePhoneNumber(state.phoneNumber.value);
                          },
                        )),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ));
        });
  }
}

/*class _EmailBox extends StatelessWidget {
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
                      suffixIcon: _SubmitButton(
                        visible: state.email.valid,
                        onPressed: () {
                          context
                              .read<AuthenticationBloc>()
                              .changeEmail(state.email.value);
                        },
                      ),
                    ),
                  )
                ],
              ));
        });
  }
}
*/

// ?
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

// ?
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

// TODO: Should give feedback when it succesfully changes password.
class ChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(builder: (context, state) {
      bool canSubmit = (state.newConfirmedPassword.valid &&
          state.newPassword.valid &&
          !state.newPassword.pure &&
          !state.newConfirmedPassword.pure);

      return ConfirmationDialog(
        confirmWidget: canSubmit
            ? const Text(
                'Submit',
                style: const TextStyle(color: Colors.black),
              )
            : const Text(
                'Invalid',
                style: const TextStyle(color: Colors.black),
              ),
        title: const Text('Password Reset'),
        snippet: Column(
          children: [
            _NewPassword(),
            const SizedBox(
              height: 32,
            ),
            _NewPasswordConfirm(),
          ],
        ),
        onConfirm: canSubmit
            ? () {
                context
                    .read<AuthenticationBloc>()
                    .changePassword(state.newPassword.value);
                // Going to have to alert user when fails on firebase end.
                Navigator.pop(context);
              }
            :
            // Invalid Submission
            () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                    elevation: 20,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    duration: Duration(seconds: 1, milliseconds: 500),
                    backgroundColor: Colors.black,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(5, 5))),
                    content: Text(
                      'Invalid Submission',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: CustomColors.gold,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ));
              },
      );
    });
  }
}

class _NewPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.newPassword != current.newPassword,
      builder: (context, state) {
        return TextField(
          obscureText: true,
          onChanged: (value) =>
              context.read<SettingsCubit>().onNewPasswordChanged(value),
          decoration: InputDecoration(
            labelText: 'New Password',
            hintText: 'secret',
            errorText: state.newPassword.invalid ? 'Invalid password' : null,
            border: OutlineInputBorder(),
            filled: true,
            contentPadding: EdgeInsets.all(10),
          ),
        );
      },
    );
  }
}

class _NewPasswordConfirm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.newConfirmedPassword != current.newConfirmedPassword,
      builder: (context, state) {
        return TextField(
          obscureText: true,
          onChanged: (value) => context
              .read<SettingsCubit>()
              .onNewConfirmedPasswordChanged(value),
          decoration: InputDecoration(
            labelText: 'New Password Confirm',
            hintText: 'secret',
            errorText:
                state.newConfirmedPassword.invalid ? 'Invalid password' : null,
            border: OutlineInputBorder(),
            filled: true,
            contentPadding: EdgeInsets.all(10),
          ),
        );
      },
    );
  }
}
