import 'package:flutter/material.dart';

class ErrorDialogSignIn extends StatelessWidget {
  final String? errorMessage;
  const ErrorDialogSignIn({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: Text(errorMessage!),
      actions: [
        TextButton(
          child: const Text("Ok"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}