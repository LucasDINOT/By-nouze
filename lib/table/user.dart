class User {
  int? id;
  String email;
  String password;
  String pseudo;
  String firstName;
  String lastName;
  int phoneNumber;
  String profilePicture;

  User({
    required this.email,
    required this.password,
    required this.pseudo,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.profilePicture = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'pseudo': pseudo,
      'firstname': firstName,
      'lastname': lastName,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
    };
  }
}
