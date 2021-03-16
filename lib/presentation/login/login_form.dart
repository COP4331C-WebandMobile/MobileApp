import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:roomiesMobile/business_logic/login/cubit/login_cubit.dart';
import 'package:roomiesMobile/presentation/register/register_page.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Authentication Failure')));
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
              errorText: state.email.invalid ? 'Invalid Email' : null,
            ),
          );
        });
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();

    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return TextField(
            controller: _controller,
            key: const Key('loginForm_emailInput_textField'),
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
              errorText: state.password.invalid ? 'Invalid password' : null,
              suffixIcon: IconButton(
                onPressed: () {return const Tooltip(message: 'message', child: Text('O'),);},
                icon: Icon(Icons.info),
              ),
            ),
          );
        });
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return state.status.isSubmissionInProgress
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
                    onPressed: state.status.isValidated
                        ? () =>
                            context.read<LoginCubit>().logInWithCredentials()
                        : (() {}),
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
