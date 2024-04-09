import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:messenger/features/auth/presentation/pages/sign_up/sign_up_page.dart';

class SignInNavigate extends StatelessWidget {
  const SignInNavigate();

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: <TextSpan>[
          const TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(
                color: Color(0xFF9E9E9E),
              )),
          TextSpan(
              recognizer: TapGestureRecognizer()
                // ignore: unnecessary_set_literal
                ..onTap = () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      )
                    },
              text: "Sign Up here",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              )),
        ]));
  }
}
