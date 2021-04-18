import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/password_reset/cubit/password_reset_cubit.dart';
import 'package:formz/formz.dart';
import 'package:roomiesMobile/presentation/login/login_page.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';

class PasswordResetForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordResetCubit, PasswordResetState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(
              content: Text('Failed to send password reset.'),
              backgroundColor: CustomColors.gold,
            ));
        } else if (state.status.isSubmissionSuccess) {
          Navigator.of(context).push<void>(LoginPage.route());

          Future.delayed(Duration(milliseconds: 500), () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Recovery email has been sent.'),
                backgroundColor: CustomColors.gold,
              ));
          });
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white,
                        width: 5,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.black,
                  ),
                  padding: EdgeInsets.only(bottom: 15, left: 30, right: 30),
                  child: const Text(
                    'Password Reset',
                    textScaleFactor: 2,
                    style: TextStyle(height: 3, color: Colors.white),
                  )),
              const SizedBox(
                height: 16.0,
              ),
              _EmailInput(),
              const SizedBox(
                height: 16.0,
              ),
              _PasswordResetButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordResetCubit, PasswordResetState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('passwordResetForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<PasswordResetCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            labelText: 'Email',
            helperText: '',
            hintText: 'example@gmail.com',
            errorText: state.email.invalid ? 'Invalid Email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordResetCubit, PasswordResetState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return state.status.isSubmissionInProgress
              ? const CircularProgressIndicator()
              : Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    key: const Key('passwordResetForm_submit_raisedButton'),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text('SUBMIT'),
                    onPressed: state.status.isValidated
                        ? () => context
                            .read<PasswordResetCubit>()
                            .requestPasswordReset()
                        : (() {}),
                  ),
                );
        });
  }
}
