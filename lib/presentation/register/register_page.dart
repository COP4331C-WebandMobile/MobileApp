import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/register/cubit/register_cubit.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';
import 'package:roomiesMobile/widgets/appbar.dart';
import 'register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
        backgroundColor: CustomColors.gold,
        appBar: Bar(),
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          height: mediaQuery.size.height / 2,
          width: mediaQuery.size.width,
          margin: EdgeInsets.all(32.0),
          child: Column(children: [
            Text(
              "Create An Account",
              style: TextStyle(fontSize: 30),
            ),
            BlocProvider<RegisterCubit>(
              create: (_) => RegisterCubit(
                  context.read<AuthenticationRepository>()), //call back
              child: Expanded(child: RegisterForm()),
            ),
          ]),
        ));
  }
}
