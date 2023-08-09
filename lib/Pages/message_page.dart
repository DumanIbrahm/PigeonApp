import 'package:flutter/material.dart';
import 'package:pigeon_app/models/message_model.dart';
import 'package:pigeon_app/models/user_model.dart';
import 'package:pigeon_app/palette.dart';
import 'package:pigeon_app/viewModels/user_view_model.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  final MyUser? currentUser;
  final MyUser? chatUser;
  const MessagePage({super.key, this.currentUser, this.chatUser});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController controllerText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final UserViewModel? userModel = Provider.of<UserViewModel?>(context);
    MyUser currentUser = widget.currentUser!;
    MyUser chatUser = widget.chatUser!;
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: Pallete.appBarColor,
        title: const Text("Messages"),
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
                stream: userModel!.getMessages(currentUser.uid, chatUser.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<MessageModel> list = snapshot.data!;
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return chats(list[index]);
                    },
                  );
                }),
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: controllerText,
                    cursorColor: Colors.blueGrey,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Type a message",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none)),
                  )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: FloatingActionButton(
                        backgroundColor: Pallete.appBarColor,
                        onPressed: () async {
                          if (controllerText.text.trim().length > 0) {
                            MessageModel messageModel = MessageModel(
                              fromWho: currentUser.uid,
                              toWho: chatUser.uid,
                              fromMe: true,
                              message: controllerText.text,
                            );

                            var result =
                                await userModel.saveMessage(messageModel);
                            if (result!) {
                              controllerText.clear();
                            }
                          }
                        },
                        child: const Icon(
                          Icons.send,
                          size: 35,
                          color: Colors.white,
                        ),
                      )),
                ],
              ))
        ],
      )),
    );
  }

  Widget? chats(MessageModel currentMessage) {
    Color _color = currentMessage.fromMe! ? Colors.blue : Colors.grey;
    if (currentMessage.fromMe!) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: _color,
            ),
            child: Text(
              currentMessage.message!,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ]),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.chatUser!.profilUrl!),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: _color,
                  ),
                  child: Text(currentMessage.message!,
                      style: const TextStyle(color: Colors.white)),
                )
              ],
            )
          ],
        ),
      );
    }
  }
}
