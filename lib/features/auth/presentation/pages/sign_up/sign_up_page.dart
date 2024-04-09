import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/auth/presentation/pages/sign_up/sign_up_widgets/display_field.dart';
import 'package:messenger/features/auth/presentation/pages/sign_up/sign_up_widgets/email_field.dart';
import 'package:messenger/features/auth/presentation/pages/sign_up/sign_up_widgets/error_dialog.dart';
import 'package:messenger/features/auth/presentation/pages/sign_up/sign_up_widgets/password_field.dart';
import 'package:messenger/features/auth/presentation/pages/sign_up/sign_up_widgets/submit_button.dart';
import 'package:messenger/features/form-validation/form_bloc/form_bloc.dart';
import 'package:messenger/features/form-validation/form_bloc/form_event.dart';
import 'package:messenger/features/form-validation/form_bloc/form_state.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FormBloc, FormsState>(
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (context) => ErrorDialogSignUp(
                        errorMessage: state.errorMessage,
                      ));
            } 
            // else if (state.isFormValid && !state.isLoading) {
            //   context.read<FormBloc>().add(const FormSucceeded());
            // }
          },
        )
      ],
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: const Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Register Now!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        )),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    EmailFieldSignUp(),
                    SizedBox(height: 20),
                    PasswordFieldSignUp(),
                    SizedBox(height: 20),
                    DisplayNameFieldSignUp(),
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    SubmitButtonSignUp(),
                  ]),
            ),
          )),
    );
  }
}
