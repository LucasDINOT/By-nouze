class Comment {
  int? id;
  int idPost;
  int idUser;
  String description;

  Comment({
    this.id,
    required this.idPost,
    required this.idUser,
    required this.description,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      idPost: map['id_post'],
      idUser: map['id_user'],
      description: map['description'],
    );
  }
}
