import 'package:flutter/material.dart';
import 'package:messenger/features/auth/presentation/pages/welcome_page.dart';

class ErrorDialogSignUp extends StatelessWidget {
  final String? errorMessage;
  const ErrorDialogSignUp({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(41, 47, 63, 1),
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