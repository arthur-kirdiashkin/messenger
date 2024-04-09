import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_event.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_state.dart';
import 'package:messenger/features/auth/presentation/pages/home_page.dart';
import 'package:messenger/features/auth/presentation/pages/sign_in/sign_in_widgets/email_field.dart';
import 'package:messenger/features/auth/presentation/pages/sign_in/sign_in_widgets/error_dialog.dart';
import 'package:messenger/features/auth/presentation/pages/sign_in/sign_in_widgets/password_field.dart';
import 'package:messenger/features/auth/presentation/pages/sign_in/sign_in_widgets/sign_in_navigate.dart';
import 'package:messenger/features/auth/presentation/pages/sign_in/sign_in_widgets/submit_button.dart';
import 'package:messenger/features/auth/presentation/blocs/form_bloc/form_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/form_bloc/form_state.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiBlocListener(
      listeners: [
        BlocListener<FormBloc, FormsState>(
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      ErrorDialogSignIn(errorMessage: state.errorMessage));
            }
            if (state.isFormValidateFailed) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please fill the data correctly!")));
            }
            if (state.isFormValid && !state.isLoading) {
              context.read<AuthenticationBloc>().add(AuthenticationStarted());
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state.authenticationStatus == AuthenticationStatus.success) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()));
            }
          },
        ),
      ],
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.white),
          ),
          body: Center(
              child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "Welcome back!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        )),
                  ])),
              SizedBox(height: 20),
              const Text(
                "You've been missed!",
                style: TextStyle(color: Colors.white),
              ),
              Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
              const EmailFieldSignIn(),
              SizedBox(height: 20),
              const PasswordFieldSignIn(),
              SizedBox(height: 20),
              const SubmitButtonSignIn(),
              const SignInNavigate(),
            ]),
          ))),
    );
  }
}
