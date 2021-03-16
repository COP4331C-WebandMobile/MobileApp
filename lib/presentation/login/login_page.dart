import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/login/cubit/login_cubit.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: <Widget>[
        Container(
          color: CustomColors.gold,
          height: mediaQuery.size.height / 4,
          width: mediaQuery.size.width,
          child: Center( child: Text(
          'ROOMIES',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 52,
          ),
          ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32),
          child: BlocProvider(
            create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
            child: LoginForm(),
          ),
        ),
      ]),
    );
  }
}
