import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_state.dart';
import 'package:messenger/features/auth/presentation/blocs/chat_bloc/chat_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/chat_bloc/chat_event.dart';
import 'package:messenger/features/auth/presentation/pages/chat_page.dart';
import 'package:messenger/features/auth/presentation/pages/settings/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (_, state) {
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
                padding: const EdgeInsets.only(left: 10),
                child: ProfilePicture(
                  name: state.hiveUser!.displayName!,
                  radius: 10,
                  fontsize: 20,
                  tooltip: true,
                ),
              ),
              title: Text(
                '${state.hiveUser!.displayName}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      context.read<ChatBloc>()
                        ..add(LoadChatEvent())
                        ..add(StreamLoadEvent());
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Chatpage()));
                    },
                    child: const Card(
                        color: Color.fromRGBO(68, 73, 85, 1),
                        child: ListTile(
                          title: Center(
                            child: Text(
                              'Open Chat',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )),
                  ),
                )
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
