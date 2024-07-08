class DetailModal {
  String firstName;
  String lastName;
  String contact;
  String email;
  String image;

  DetailModal({
    required this.firstName,
    required this.lastName,
    required this.contact,
    required this.email,
    required this.image,
  });

  factory DetailModal.fromMap({required Map data}) {
    return DetailModal(
      firstName: data['firstName'],
      lastName: data['lastName'],
      contact: data['contact'],
      email: data['email'],
      image: data['image'],
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'contact': contact,
      'email': email,
      'image': image,
    };
  }
}
