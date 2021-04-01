
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:roomiesMobile/business_logic/register/cubit/register_cubit.dart';
import 'package:formz/formz.dart';
import 'package:roomiesMobile/presentation/login/login_page.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';

class RegisterForm extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>( //The parent will provide the bloc
      listener: (context, state) {
        if (state.status.isSubmissionFailure) 
        {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Sign Up Failure')),
            );
        }
        else if(state.status.isSubmissionSuccess)
        {
          Navigator.of(context).push<void>(LoginPage.route());

          Future.delayed(Duration(milliseconds: 500), () {
            ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Email verification sent, verify to login.'),
              backgroundColor: CustomColors.gold,
            )
          );
          });
        }
        else if(state.status.isSubmissionInProgress)
        {
          return Center(child: CircularProgressIndicator(),);
        }
      },
      child: Align(
        //alignment: const Alignment(0, -1 / 3),
        child: Container(
          padding: EdgeInsets.all(20),

          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child:
              _EmailInput(),
            ),

            Expanded(
            child:
            _PasswordInput(),
            ),

            Expanded(
            child:
            _ConfirmPasswordInput(),
            ),

            Expanded(
            child:
            _PhoneNumberInput(),
            ),

             Expanded(
            child:
            _FirstNameInput(),
            ),


           Expanded(
            child:
            _LastNameInput(),
            ),


            Expanded(
            child: Row(
              children:[
                Expanded(
              child:_SignUpButton())]
             )),
            
          ],
        ),
      ),
    ));
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.email != current.email, //Takes the previous bloc state and current bloc state and returns a boolean. If returns true , builder will be called with state and the widget will rebuild.
      builder: (context, state) { //The builder function which will be invoked on each widget build. The builder takes the BuildContext and current state and must return a widget
        return TextField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (email) => context.read<RegisterCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email',
            helperText: '',
            errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}
class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.phoneNumber != current.phoneNumber, //Takes the previous bloc state and current bloc state and returns a boolean. If returns true , builder will be called with state and the widget will rebuild.
      builder: (context, state) { //The builder function which will be invoked on each widget build. The builder takes the BuildContext and current state and must return a widget
        return TextField(
          key: const Key('signUpForm_phoneNumberInput_textField'),
          onChanged: (phoneNumber) => context.read<RegisterCubit>().phoneNumberChanged(phoneNumber),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            hintText: '4078586677',
            helperText: '',
            errorText: state.email.invalid ? 'Invalid phone number' : null,
          ),
        );
      },
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName, //Takes the previous bloc state and current bloc state and returns a boolean. If returns true , builder will be called with state and the widget will rebuild.
      builder: (context, state) { //The builder function which will be invoked on each widget build. The builder takes the BuildContext and current state and must return a widget
        return TextField(
          key: const Key('signUpForm_firstNameInput_textField'),
          onChanged: (firstName) => context.read<RegisterCubit>().firstNameChanged(firstName),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'First Name',
            hintText: 'John',
            helperText: '',
            errorText: state.firstName.invalid ? 'Invalid name.' : null,
          ),
        );
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (previous, current) => previous.lastName != current.lastName, //Takes the previous bloc state and current bloc state and returns a boolean. If returns true , builder will be called with state and the widget will rebuild.
        builder: (context, state) { //The builder function which will be invoked on each widget build. The builder takes the BuildContext and current state and must return a widget
          return TextField(
            key: const Key('signUpForm_lastNameInput_textField'),
            onChanged: (lastName) => context.read<RegisterCubit>().lastNameChanged(lastName),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Last Name',
              hintText: 'Doe',
              helperText: '',
              errorText: state.lastName.invalid ? 'Invalid name.' : null,
            ),
          );
        },
      );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<RegisterCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            helperText: '',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
          builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          onChanged: (confirmPassword) => context
              .read<RegisterCubit>()
              .confirmedPasswordChanged(confirmPassword),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'confirm password',
            helperText: '',
            errorText: state.confirmedPassword.invalid
                ? 'passwords do not match'
                : null,
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signUpForm_continue_raisedButton'),
                child: const Text('SIGN UP'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  primary: Colors.black,
                ),
                onPressed: state.status.isValidated
                    ? () => context.read<RegisterCubit>().signUpFormSubmitted()
                    : null,
              );
      },
    );
  }
}