import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/form_bloc/form_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/form_bloc/form_event.dart';
import 'package:messenger/features/auth/presentation/blocs/form_bloc/form_state.dart';

class SubmitButtonSignUp extends StatelessWidget {
  const SubmitButtonSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormsState>(
      builder: (context, state) {
        return SizedBox(
          width: 320,
          child: OutlinedButton(
            onPressed: !state.isFormValid
                ? () => context
                    .read<FormBloc>()
                    .add(const FormSubmitted(value: FormStatus.signUp))
                : null,
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(122, 129, 148, 1)),
                side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
            child: const Text("Sign Up"),
          ),
        );
      },
    );
  }
}