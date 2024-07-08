import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';
import '../../models/detail_model.dart';
import '../../models/friend_modell.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "iChat",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo.shade900,
        actions: [
          IconButton(
            onPressed: () async {
              await Auth.auth.signOut().then(
                    (value) => Navigator.of(context).pushReplacementNamed('/'),
                  );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FireStoreHelper.fireStoreHelper.getFriendList(),
        builder: (context, snapShot) {
          QuerySnapshot<Map<String, dynamic>>? data = snapShot.data;
          List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
              data?.docs ?? [];
          List<FriendModal> allFriends =
              allDocs.map((e) => FriendModal.fromMap(data: e.data())).toList();

          if (snapShot.hasData) {
            return ListView.builder(
              itemCount: allFriends.length,
              itemBuilder: (context, index) {
                FriendModal friendModal = allFriends[index];
                return ListTile(
                  onTap: () async {
                    await FireStoreHelper.fireStoreHelper
                        .updateStatus(id: friendModal.email);

                    Navigator.of(context).pushNamed(
                      'chat_page',
                      arguments: friendModal,
                    );
                  },
                  leading: CircleAvatar(
                    foregroundImage: FileImage(
                      File(friendModal.profilePic),
                    ),
                    radius: 25,
                  ),
                  title: Text(
                    "${friendModal.firstName} ${friendModal.lastName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(friendModal.lastMessage),
                  trailing: (friendModal.status == "unseen")
                      ? Container(
                          color: Colors.blue,
                          child: Text(friendModal.messageCount.toString()),
                        )
                      : Text(""),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.indigo.shade900,
              elevation: 0,
              title: const Text(
                "Add Friend",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade900,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: StreamBuilder(
                      stream: FireStoreHelper.fireStoreHelper.getUserData(),
                      builder: (context, snapShot) {
                        if (snapShot.hasData) {
                          QuerySnapshot<Map<String, dynamic>>? data =
                              snapShot.data;
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              allDocs = data?.docs ?? [];
                          List<DetailModal> allDetails = allDocs
                              .map((e) => DetailModal.fromMap(data: e.data()))
                              .toList();

                          return ListView.builder(
                            itemCount: allDetails.length,
                            itemBuilder: (context, index) {
                              DetailModal detailModal = allDetails[index];

                              return ListTile(
                                onTap: () async {
                                  await FireStoreHelper.fireStoreHelper
                                      .addFriend(detailModal: detailModal)
                                      .then(
                                        (value) => Navigator.of(context).pop(),
                                      );
                                },
                                leading: CircleAvatar(
                                  radius: 25,
                                  foregroundImage: FileImage(
                                    File(detailModal.image),
                                  ),
                                ),
                                title: Text(
                                  "${detailModal.firstName} ${detailModal.lastName}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.indigo.shade900,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
