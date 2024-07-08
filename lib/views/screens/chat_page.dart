import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';
import '../../models/chat_model.dart';
import '../../models/friend_modell.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  User? user = Auth.auth.firebaseAuth.currentUser;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state.name == "resumed") {}

    log("=============================");
    log("Current State :- ${state.name}");
    log("=============================");
  }

  TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FriendModal friendModal =
        ModalRoute.of(context)!.settings.arguments as FriendModal;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("${friendModal.firstName} ${friendModal.lastName}"),
            Text(friendModal.isOnline == true
                ? 'Online'
                : "${friendModal.lastActive.hour}:${friendModal.lastActive.minute}"),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 7),
        child: StreamBuilder(
          stream: FireStoreHelper.fireStoreHelper.getChats(
              senderId: user!.email as String, receiverId: friendModal.email),
          builder: (context, snapShot) {
            QuerySnapshot<Map<String, dynamic>>? data = snapShot.data;
            List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                data?.docs ?? [];
            List<ChatModal> allChats =
                allDocs.map((e) => ChatModal.fromMap(data: e.data())).toList();

            if (snapShot.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: allChats.length,
                      itemBuilder: (context, index) {
                        ChatModal chatModal = allChats[index];

                        return Row(
                          mainAxisAlignment: chatModal.type == 'sent'
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                if (chatModal.msg !=
                                    "This Message was deleted") {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return chatModal.type == 'sent'
                                          ? CupertinoAlertDialog(
                                              content: IconButton(
                                                color: Colors.red,
                                                onPressed: () {
                                                  FireStoreHelper
                                                      .fireStoreHelper
                                                      .deleteChat(
                                                    senderId:
                                                        user?.email as String,
                                                    receiverId:
                                                        friendModal.email,
                                                    chatModal: chatModal,
                                                  );

                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(
                                                    CupertinoIcons.delete),
                                              ),
                                            )
                                          : const Text("");
                                    },
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: chatModal.type == 'sent'
                                      ? Colors.blue.shade500
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      chatModal.msg,
                                      style: TextStyle(
                                          color: chatModal.type == 'sent'
                                              ? Colors.white
                                              : Colors.blue.shade500,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Transform.translate(
                                      offset: Offset(1, 4),
                                      child: Text(
                                        "${chatModal.dateTime.hour}:${chatModal.dateTime.minute.toString().padLeft(2, '0')}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    chatModal.type == 'sent' &&
                                            chatModal.msg !=
                                                "This Message was deleted"
                                        ? Transform.translate(
                                            offset: const Offset(1, 4),
                                            child: Icon(
                                              Icons.done,
                                              size: 17,
                                              color: Colors.grey.shade400,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextField(
                          controller: chatController,
                          decoration: const InputDecoration(
                            hintText: "Message",
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: FloatingActionButton(
                          onPressed: () {
                            ChatModal chatModal = ChatModal(
                              msg: chatController.text,
                              type: 'sent',
                              dateTime: DateTime.now(),
                            );

                            FireStoreHelper.fireStoreHelper
                                .sentMessage(
                              chatModal: chatModal,
                              senderId: user?.email as String,
                              receiverId: friendModal.email,
                            )
                                .then(
                              (value) async {
                                chatController.clear();
                                await FireStoreHelper.fireStoreHelper
                                    .updateStatus2(id: friendModal.email);

                                await FireStoreHelper.fireStoreHelper
                                    .getLastMessage(
                                        id: friendModal.email,
                                        msg: chatModal.msg,
                                        friendModal: friendModal);

                                await FireStoreHelper.fireStoreHelper
                                    .unseenCount(
                                        id: friendModal.email,
                                        friendModal: friendModal);

                                log("=====================================");
                                log(friendModal.lastMessage.length.toString());
                                log("=====================================");
                              },
                            );
                          },
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(Icons.send),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      backgroundColor: Colors.grey.shade300,
    );
  }
}
