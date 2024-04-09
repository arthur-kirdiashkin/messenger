import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_event.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_state.dart';
import 'package:messenger/features/auth/presentation/pages/settings/log_out_button.dart';
import 'package:messenger/features/auth/presentation/pages/welcome_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.authenticationStatus == AuthenticationStatus.notSucess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomePage()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogOutButton(),
          ],
        ),
      ),
    );
  }
}
