class FriendModal {
  String firstName;
  String lastName;
  String email;
  String profilePic;
  String status;
  String lastMessage;
  int messageCount;
  bool isOnline;
  DateTime lastActive = DateTime.now();

  FriendModal({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePic,
    required this.status,
    required this.lastMessage,
    required this.messageCount,
    required this.isOnline,
    required this.lastActive,
  });

  factory FriendModal.fromMap({required Map data}) {
    return FriendModal(
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      profilePic: data['profilePic'],
      status: data['status'],
      lastMessage: data['lastMessage'],
      messageCount: data['messageCount'],
      isOnline: data['isOnline'],
      lastActive: DateTime.fromMillisecondsSinceEpoch(data['lastActive']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePic': profilePic,
      'status': status,
      'lastMessage': lastMessage,
      'messageCount': messageCount,
      'isOnline': isOnline,
      'lastActive': lastActive.millisecondsSinceEpoch,
    };
  }
}
