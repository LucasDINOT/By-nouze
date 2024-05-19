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
    this.id,
    required this.email,
    required this.password,
    required this.pseudo,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.profilePicture = "",
  });

factory User.fromMap(Map<String, dynamic> map) {
  return User (
    id: map['id'],
    email: map['email'],
    password: map['password'],
    pseudo: map['pseudo'],
    firstName: map['firstname'],
    lastName: map['lastname'],
    phoneNumber: map['phoneNumber'],
    profilePicture: map['profilePicture'],
  );
}
}
