import 'package:flutter/material.dart';
import '../table/post.dart';
import '../table/comment.dart';
import '../database.dart';
import '../table/user.dart';

class ViewPostCommentPage extends StatefulWidget {
  final Post post;
  final User user;

  const ViewPostCommentPage({super.key, required this.post, required this.user});

  @override
  _ViewPostCommentPageState createState() => _ViewPostCommentPageState();
}

class _ViewPostCommentPageState extends State<ViewPostCommentPage> {
  late List<CommentWithPseudo> _comments = [];
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _fetchComments();
    _controller = TextEditingController();
  }

  Future<void> _fetchComments() async {
    var mysql = Mysql();
    var conn = await mysql.getConnection();

    var result = await conn.query(
      'SELECT c.*, u.pseudo FROM Comment c JOIN User u ON c.id_user = u.id WHERE c.id_post = ?',
      [widget.post.id],
    );

    await conn.close();

    setState(() {
      _comments = result.map((row) {
        return CommentWithPseudo.fromMap(row.fields); 
      }).toList();
    });
  }

  void _submitComment(String comment) async {
    var mysql = Mysql();
    var conn = await mysql.getConnection();

    await conn.query(
      'INSERT INTO Comment (id_post, id_user, description) VALUES (?, ?, ?)',
      [widget.post.id, widget.post.idUser, comment],
    );

    await conn.close();

    // Actualiser la liste des commentaires
    _fetchComments();

    // Effacer le champ de commentaire après soumission
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_comments[index].comment.description),
                  subtitle: Text('By: ${_comments[index].pseudo}'), 
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Write a comment...',
                    ),
                    onSubmitted: (comment) => _submitComment(comment),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _submitComment(_controller.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentWithPseudo {
  final Comment comment;
  final String pseudo;

  CommentWithPseudo({required this.comment, required this.pseudo});

  factory CommentWithPseudo.fromMap(Map<String, dynamic> map) {
    return CommentWithPseudo(
      comment: Comment.fromMap(map), 
      pseudo: map['pseudo'] ?? '',
    );
  }
}
