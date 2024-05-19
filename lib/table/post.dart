class Post {
  int? id;
  int idUser;
  DateTime date;
  String description;
  String? picture;

  Post({
    this.id,
    required this.idUser,
    required this.date,
    required this.description,
    this.picture,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      idUser: map['id_user'],
      date: map['date'], // Convertir la chaîne en DateTime
      description: map['description'],
      picture: map['picture'],
    );
  }
}