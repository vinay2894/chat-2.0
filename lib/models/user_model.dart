class UserModal {
  String id;
  String name;
  String email;
  String profilePic;

  UserModal({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePic,
  });

  factory UserModal.fromMap({required Map data}) {
    return UserModal(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      profilePic: data['profilePic'],
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePic': profilePic,
    };
  }
}
