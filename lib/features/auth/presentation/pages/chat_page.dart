import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        title: Text(
          'Chat',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state.chatStatus == ChatStatus.loading) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state.chatStatus == ChatStatus.loaded) {
                if (state.messages!.isEmpty || state.messages == null) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'Add message',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    // reverse: true,
                    itemCount: state.messages!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: state.currentUserId ==
                                state.messages![index].profileId
                            ? EdgeInsets.only(
                                top: 8, bottom: 8, left: 80, right: 35)
                            : EdgeInsets.only(
                                top: 8, bottom: 8, right: 80, left: 35),
                        decoration: BoxDecoration(
                            color: state.currentUserId ==
                                    state.messages![index].profileId
                                ? Color.fromRGBO(39, 42, 53, 1)
                                : Color.fromRGBO(55, 62, 78, 1),
                            borderRadius: BorderRadius.circular(20)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.messages![index].userName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: [
                                Row(
                                  // mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        state.messages![index].message,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                        // softWrap: true,
                                        softWrap: true,
                                        overflow: TextOverflow.clip,
                                        maxLines: 20,
                                      ),
                                    ),
                                    Text(
                                      DateFormat.jm().format(
                                          state.messages![index].createdAt),
                                      style: TextStyle(color: Colors.white),
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
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 25, top: 20, bottom: 20),
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
                      contentPadding: EdgeInsets.only(left: 20),
                      hintText: 'Write',
                      hintStyle:
                          TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6)),
                      fillColor: Color.fromARGB(39, 42, 53, 1),
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
                    context.read<ChatBloc>().add(
                        AddMessageEvent(textMessage: messageController.text));
                    messageController.clear();
                  },
                  child: Container(
                      width: 47,
                      height: 47,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(55, 62, 78, 1),
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
