

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/password_reset/cubit/password_reset_cubit.dart';
import 'package:roomiesMobile/presentation/password_reset/password_reset_form.dart';

class PasswordResetPage extends StatelessWidget {

  const PasswordResetPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const PasswordResetPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
          Padding(
            padding: const EdgeInsets.all(32),
            child: BlocProvider<PasswordResetCubit>(
              create: (_) => PasswordResetCubit(context.read<AuthenticationRepository>()),
              child: PasswordResetForm(),
            ),
          ),
    );
  }

}