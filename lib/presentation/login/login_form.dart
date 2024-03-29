import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:roomiesMobile/business_logic/login/cubit/login_cubit.dart';
import 'package:roomiesMobile/presentation/password_reset/password_reset_page.dart';
import 'package:roomiesMobile/presentation/register/register_page.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == Status.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(
                  content: Text('Authentication Failure'),
                  backgroundColor: CustomColors.gold,
                ));
        }
        else if(state.status == Status.success)
        {
          
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/house-logo.png',
                  height: 120,
                ),
                const SizedBox(height: 16.0),
                _EmailInput(),
                const SizedBox(height: 8.0),
                _PasswordInput(),
                const SizedBox(height: 8.0),
                _LoginButton(),
                const SizedBox(height: 4.0),
                _SignUpButton(),
                const SizedBox(height: 4.0),
                _ForgotPasswordText(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextField(
            inputFormatters: [
              FilteringTextInputFormatter(RegExp('[ ]'), allow: false),
            ],
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<LoginCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              labelText: 'Email',
              helperText: '',
              hintText: 'example@gmail.com',
            ),
          );
        });
  }
}

class _PasswordInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
            obscureText: true,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              labelText: 'Password',
              helperText: '',
            ),
          );
        });
  }
}

class _LoginButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        //buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return state.status == Status.inProgress
              ? const CircularProgressIndicator()
              : Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    key: const Key('loginForm_continue_raisedButton'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text('LOGIN'),
                    onPressed: () {context.read<LoginCubit>().logIn(state.email, state.password);},
                  ),
                );
        });
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        key: const Key('loginForm_createAccount_flatButton'),
        child: Text('SIGN UP'),
        onPressed: () => Navigator.of(context).push<void>(RegisterPage.route()),
      ),
    );
  }
}

class _ForgotPasswordText extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(text: 'Forgot password? ', style: TextStyle(color: Colors.black)),
          TextSpan(
            text: 'Click here',
            style: TextStyle(color:  Colors.blue),
            recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.of(context).push<void>(PasswordResetPage.route());
            }
          ),
        ],
      ),
    );
  }

}
