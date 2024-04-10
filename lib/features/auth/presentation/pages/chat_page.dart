import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:messenger/features/auth/presentation/blocs/chat_bloc/chat_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/chat_bloc/chat_event.dart';
import 'package:messenger/features/auth/presentation/blocs/chat_bloc/chat_state.dart';

class Chatpage extends StatelessWidget {
  final messageController = TextEditingController();
  Chatpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state.chatStatus == ChatStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state.chatStatus == ChatStatus.loaded) {
                if (state.messages!.isEmpty || state.messages == null) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Add message',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: state.messages!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: state.currentUserId ==
                              state.messages![index].profileId
                          ? const EdgeInsets.only(
                              top: 8, bottom: 8, left: 80, right: 35)
                          : const EdgeInsets.only(
                              top: 8, bottom: 8, right: 80, left: 35),
                      decoration: BoxDecoration(
                          color: state.currentUserId ==
                                  state.messages![index].profileId
                              ? const Color.fromRGBO(39, 42, 53, 1)
                              : const Color.fromRGBO(55, 62, 78, 1),
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.messages![index].userName,
                            style: const TextStyle(
                                color: Colors.white, fontFamily: 'Roboto'),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      state.messages![index].message,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: 'Roboto',
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.clip,
                                      maxLines: 20,
                                    ),
                                  ),
                                  Text(
                                    DateFormat.jm().format(
                                      state.messages![index].createdAt,
                                    ),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Roboto'),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              if (state.chatStatus == ChatStatus.error) {
                return Center(
                  child: Text('${state.errorMessage}'),
                );
              }
              return const SizedBox.shrink();
            },
          )),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 20, bottom: 20),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextFormField(
                    controller: messageController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20),
                      hintText: 'Write',
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.6),
                          fontFamily: 'Helvetica'),
                      fillColor: const Color.fromARGB(39, 42, 53, 1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (messageController.text.trim().isNotEmpty) {
                      context.read<ChatBloc>().add(
                          AddMessageEvent(textMessage: messageController.text));
                      messageController.clear();
                    }
                  },
                  child: Container(
                      width: 47,
                      height: 47,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(55, 62, 78, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.asset('assets/Union.png')),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
