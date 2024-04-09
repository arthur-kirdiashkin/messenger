import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_event.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AuthenticationBloc>().add(AuthenticationSignedOut());
      },
      child: const Card(
          color: Color.fromRGBO(68, 73, 85, 1),
          child: ListTile(
            trailing: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            title: Text(
              'Log out of your account',
              style: TextStyle(color: Colors.white),
            ),
          )),
    );
  }
}