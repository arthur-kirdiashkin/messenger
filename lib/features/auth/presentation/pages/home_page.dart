import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_state.dart';
import 'package:messenger/features/auth/presentation/blocs/chat_bloc/chat_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/chat_bloc/chat_event.dart';
import 'package:messenger/features/auth/presentation/pages/chat_page.dart';
import 'package:messenger/features/auth/presentation/pages/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state.authenticationStatus == AuthenticationStatus.success) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                    },
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    )),
              ],
              leading: Padding(
                padding: EdgeInsets.only(left: 10),
                child: ProfilePicture(
                  name: state.hiveUser!.displayName!,
                  radius: 10,
                  fontsize: 20,
                  tooltip: true,
                ),
              ),
              title: Text(
                '${state.hiveUser!.displayName}',
                style: TextStyle(color: Colors.white),
              ),
              // centerTitle: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      context.read<ChatBloc>().add(LoadChatEvent());
                      // context.read<ChatBloc>().add(TwoSeccondsLoadEvent());
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Chatpage()));
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('Open Chat')],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
