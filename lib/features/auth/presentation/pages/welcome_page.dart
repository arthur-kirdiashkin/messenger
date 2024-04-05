import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/features/auth/presentation/pages/sign_in_page.dart';
import 'package:messenger/features/auth/presentation/pages/sign_up_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              )),
          SizedBox(height: size.height * 0.01),
          SizedBox(height: size.height * 0.1),
          SizedBox(
            width: size.width * 0.8,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(122, 129, 148, 1)),
                  side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
              child: const Text('Get Started'),
            ),
          ),
          SizedBox(
            width: size.width * 0.8,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(55, 62, 78, 1)),
                  side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
              child: const Text(
                "Sign Up",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
