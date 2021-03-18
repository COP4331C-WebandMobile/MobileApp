
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/password_reset/cubit/password_reset_cubit.dart';
import 'package:formz/formz.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';

class PasswordResetForm extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordResetCubit, PasswordResetState>(
      listener: (context, state) {
        if(state.status.isSubmissionFailure)
        {
          ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Failed to send password reset.'),
              backgroundColor: CustomColors.gold,
            )
          );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0,),
              _EmailInput(),
              const SizedBox(height: 16.0,),
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
      buildWhen:  (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<PasswordResetCubit>().emailChanged(email),
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
                    key: const Key('loginForm_continue_raisedButton'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text('LOGIN'),
                    onPressed: state.status.isValidated
                        ? () =>
                            context.read<PasswordResetCubit>().requestPasswordReset()
                        : (() {}),
                  ),
                );
        });
  }
}