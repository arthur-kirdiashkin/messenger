import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/form-validation/form_bloc/form_bloc.dart';
import 'package:messenger/features/form-validation/form_bloc/form_event.dart';
import 'package:messenger/features/form-validation/form_bloc/form_state.dart';

class EmailFieldSignIn extends StatelessWidget {
  const EmailFieldSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsState>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              context.read<FormBloc>().add(EmailChanged(value));
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(color: Colors.white),
              helperText: 'A complete, valid email e.g. joe@gmail.com',
              helperStyle: const TextStyle(color: Colors.white),
              errorText: !state.isEmailValid
                  ? 'Please ensure the email entered is valid'
                  : null,
              hintText: 'Email',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEFEFEF), width: 3.0)),
            ),
          ),
        );
      },
    );
  }
}
