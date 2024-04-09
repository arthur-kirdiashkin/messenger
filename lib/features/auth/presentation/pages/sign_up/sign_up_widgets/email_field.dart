import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/form_bloc/form_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/form_bloc/form_event.dart';
import 'package:messenger/features/auth/presentation/blocs/form_bloc/form_state.dart';

class EmailFieldSignUp extends StatelessWidget {
  const EmailFieldSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormsState>(
      builder: (context, state) {
        return SizedBox(
          width: 320,
          child: TextFormField(
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                context.read<FormBloc>().add(EmailChanged(value));
              },
              onFieldSubmitted: (value) {},
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.white),
                helperText: 'A complete, valid email e.g. joe@gmail.com',
                errorText: !state.isEmailValid
                    ? 'Please ensure the email entered is valid'
                    : null,
                helperStyle: const TextStyle(color: Colors.white),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFEFEFEF), width: 3.0)),
              )),
        );
      },
    );
  }
}