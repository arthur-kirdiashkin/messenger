import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/form-validation/form_bloc/form_bloc.dart';
import 'package:messenger/features/form-validation/form_bloc/form_event.dart';
import 'package:messenger/features/form-validation/form_bloc/form_state.dart';

class PasswordFieldSignUp extends StatelessWidget {
  const PasswordFieldSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormsState>(
      builder: (context, state) {
        return SizedBox(
          width: 320,
          child: TextFormField(
            style: const TextStyle(color: Colors.white),
            obscureText: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEFEFEF), width: 3.0)),
              helperStyle: const TextStyle(color: Colors.white),
              helperText:
                  '''Password should be at least 8 characters with at least one letter and number''',
              helperMaxLines: 2,
              labelText: 'Password',
              labelStyle: const TextStyle(color: Colors.white),
              errorMaxLines: 2,
              errorText: !state.isPasswordValid
                  ? '''Password must be at least 8 characters and contain at least one letter and number'''
                  : null,
            ),
            onChanged: (value) {
              context.read<FormBloc>().add(PasswordChanged(value));
            },
          ),
        );
      },
    );
  }
}