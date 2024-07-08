import 'package:chat_app/helpers/auth_helper.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/detail_model.dart';
import 'package:chat_app/models/friend_modell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String collectionPath = "Users";
  String collection = "friends";

  Future<void> addUser({required DetailModal detailModal}) async {
    await firestore
        .collection(collectionPath)
        .doc(detailModal.email)
        .set(detailModal.toMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserData() {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;

    return firestore
        .collection(collectionPath)
        .where('email', isNotEqualTo: email)
        .snapshots();
  }

  Future<void> addFriend({required DetailModal detailModal}) async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;

    FriendModal friendModal = FriendModal(
      firstName: detailModal.firstName,
      lastName: detailModal.lastName,
      email: detailModal.email,
      profilePic: detailModal.image,
      status: "seen",
      lastMessage: "",
      messageCount: 0,
      isOnline: false,
      lastActive: DateTime.now(),
    );
    await firestore
        .collection(collectionPath)
        .doc(email)
        .collection(collection)
        .doc(detailModal.email)
        .set(friendModal.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFriendList() {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;

    return firestore
        .collection(collectionPath)
        .doc(email)
        .collection(collection)
        .snapshots();
  }

  Future<void> sentMessage(
      {required ChatModal chatModal,
      required String senderId,
      required String receiverId}) async {
    Map<String, dynamic> data = chatModal.toMap;

    data.update('type', (value) => 'rec');

    await firestore
        .collection(collectionPath)
        .doc(receiverId)
        .collection(senderId)
        .doc(chatModal.dateTime.microsecondsSinceEpoch.toString())
        .set(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats(
      {required String senderId, required String receiverId}) {
    return firestore
        .collection(collectionPath)
        .doc(senderId)
        .collection(receiverId)
        .snapshots();
  }

  deleteChat(
      {required String senderId,
      required String receiverId,
      required ChatModal chatModal}) async {
    Map<String, dynamic> data = chatModal.toMap;

    data.update('msg', (value) => 'This Message was deleted');
    data.update('type', (value) => 'sent');

    await firestore
        .collection(collectionPath)
        .doc(senderId)
        .collection(receiverId)
        .doc(chatModal.dateTime.microsecondsSinceEpoch.toString())
        .update(data);

    data.update('msg', (value) => 'This Message was deleted');
    data.update('type', (value) => 'rec');

    await firestore
        .collection(collectionPath)
        .doc(receiverId)
        .collection(senderId)
        .doc(chatModal.dateTime.microsecondsSinceEpoch.toString())
        .update(data);
  }

  Future<void> updateStatus({required String id}) async {
    User? user = Auth.auth.firebaseAuth.currentUser;
    await firestore
        .collection(collectionPath)
        .doc(user?.email)
        .collection(collection)
        .doc(id)
        .update({'status': "seen"});
  }

  Future<void> updateStatus2({required String id}) async {
    User? user = Auth.auth.firebaseAuth.currentUser;
    await firestore
        .collection(collectionPath)
        .doc(id)
        .collection(collection)
        .doc(user?.email)
        .update({'status': "unseen"});
  }

  Future<void> getLastMessage(
      {required String id,
      required String msg,
      required FriendModal friendModal}) async {
    User? user = Auth.auth.firebaseAuth.currentUser;

    await firestore
        .collection(collectionPath)
        .doc(user?.email)
        .collection(collection)
        .doc(id)
        .update({'lastMessage': msg});

    await firestore
        .collection(collectionPath)
        .doc(id)
        .collection(collection)
        .doc(user?.email)
        .update({'lastMessage': msg});
  }

  unseenCount({required String id, required FriendModal friendModal}) async {
    int count = friendModal.messageCount;

    if (friendModal.status == "unseen") {
      count++;
    } else {
      count = 0;
    }

    User? user = Auth.auth.firebaseAuth.currentUser;
    await firestore
        .collection(collectionPath)
        .doc(id)
        .collection(collection)
        .doc(user?.email)
        .update({'messageCount': count});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> userInfo(
      {required FriendModal friendModal}) {
    User? user = Auth.auth.firebaseAuth.currentUser;

    return firestore
        .collection(collectionPath)
        .doc(user?.email)
        .collection(collection)
        .where('email', isEqualTo: friendModal.email)
        .snapshots();
  }

  updateActiveStatus({required bool isOnline, required String id}) {
    User? user = Auth.auth.firebaseAuth.currentUser;
    firestore
        .collection(collectionPath)
        .doc(user?.email)
        .collection(collection)
        .doc(id)
        .update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }
}
