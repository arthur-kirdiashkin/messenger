import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/auth/presentation/pages/welcome_page.dart';
import 'package:messenger/features/form-validation/form_bloc/form_bloc.dart';
import 'package:messenger/features/form-validation/form_bloc/form_event.dart';
import 'package:messenger/features/form-validation/form_bloc/form_state.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FormBloc, FormsState>(
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                        errorMessage: state.errorMessage,
                      ));
            } else if (state.isFormValid && !state.isLoading) {
              context.read<FormBloc>().add(const FormSucceeded());
            }
          },
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {
            Navigator.of(context).pop();
          }, icon: Icon(Icons.arrow_back), ),
        ),
          body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Register Now!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                )),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            EmailField(),
            SizedBox(height: 20),
            PasswordField(),
            SizedBox(height: 20),
            DisplayNameField(),
            SizedBox(height: 20),
            SizedBox(height: 20),
            SubmitButton()
          ]),
        ),
      )),
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormsState>(
      builder: (context, state) {
        return SizedBox(
          width: 320,
          child: TextFormField(
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                context.read<FormBloc>().add(EmailChanged(value));
              },
              onFieldSubmitted: (value) {},
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                helperText: 'A complete, valid email e.g. joe@gmail.com',
                errorText: !state.isEmailValid
                    ? 'Please ensure the email entered is valid'
                    : null,
                helperStyle: TextStyle(color: Colors.white),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFEFEFEF), width: 3.0)),
              )),
        );
      },
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormsState>(
      builder: (context, state) {
        return SizedBox(
          width: 320,
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            obscureText: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEFEFEF), width: 3.0)),
              helperStyle: TextStyle(color: Colors.white),
              helperText:
                  '''Password should be at least 7 characters with at least one letter and number''',
              helperMaxLines: 2,
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white),
              errorMaxLines: 2,
              errorText: !state.isPasswordValid
                  ? '''Password must be at least 7 characters and contain at least one letter and number'''
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

class DisplayNameField extends StatelessWidget {
  const DisplayNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormsState>(
      builder: (context, state) {
        return SizedBox(
          width: 320,
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEFEFEF), width: 3.0)),
              helperText: '''Name must be valid!''',
              helperStyle: TextStyle(color: Colors.white),
              helperMaxLines: 2,
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.white),
              errorMaxLines: 2,
              errorText:
                  !state.isNameValid ? '''Name cannot be empty!''' : null,
              errorStyle: TextStyle(color: Colors.white),
            ),
            onChanged: (value) {
              context.read<FormBloc>().add(NameChanged(value));
            },
          ),
        );
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

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
                    .add(const FormSubmitted(value: Status.signUp))
                : null,
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(122, 129, 148, 1)),
                side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
            child: const Text("Sign Up"),
          ),
        );
      },
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String? errorMessage;
  const ErrorDialog({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(41, 47, 63, 1),
      title: const Text("Error"),
      content: Text(errorMessage!),
      actions: [
        TextButton(
          child: const Text("Ok"),
          onPressed: () => errorMessage!.contains("Please Verify your email")
              ? Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                  (Route<dynamic> route) => false)
              : Navigator.of(context).pop(),
        )
      ],
    );
  }
}
