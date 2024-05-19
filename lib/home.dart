import 'package:flutter/material.dart';
import './table/user.dart';
import './table/post.dart';
import './table/comment.dart';
import './navigation_bar.dart';
import './database.dart';
import './page/modif_post_page.dart';
import './page/view_post_comment_page.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Post> _posts = [];
  late List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _fetchComments();
  }

  Future<void> _fetchPosts() async {
    var mysql = Mysql();
    var conn = await mysql.getConnection();

    var result = await conn.query('SELECT * FROM Post ORDER BY date DESC');

    await conn.close();

    setState(() {
      _posts = result.map((row) {
        return Post.fromMap(row.fields);
      }).toList();
    });
  }

  Future<void> _fetchComments() async {
    var mysql = Mysql();
    var conn = await mysql.getConnection();

    var result = await conn.query('SELECT * FROM Comment');

    await conn.close();

    setState(() {
      _comments = result.map((row) {
        return Comment.fromMap(row.fields);
      }).toList();
    });
  }

  // Méthode pour compter le nombre de commentaires pour un post spécifique
  int _commentCount(int postId) {
    // Filtrer les commentaires pour le post spécifié
    var postComments = _comments.where((comment) => comment.idPost == postId);
    return postComments.length;
  }

  // Méthode pour obtenir le pseudo de l'utilisateur associé à un post
  Future<String> _getUserPseudo(int userId) async {
    var mysql = Mysql();
    var conn = await mysql.getConnection();

    var result = await conn.query('SELECT pseudo FROM User WHERE id = ?', [userId]);
    await conn.close();

    return result.first.fields['pseudo'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('ByNouze'),
      ),
      body: _posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return FutureBuilder<String>(
            future: _getUserPseudo(_posts[index].idUser),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return _buildPostCard(_posts[index], snapshot.data!);
              }
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(user: widget.user),
    );
  }

  Widget _buildPostCard(Post post, String userPseudo) {
    bool isCurrentUserPost = post.idUser == widget.user.id;

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Posted by: $userPseudo',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text('Date: ${post.date}'),
            const SizedBox(height: 5),
            Text('Description: ${post.description}'),
            if (post.picture != null && post.picture!.isNotEmpty)
              SizedBox(
                height: 200,
                child: Image.network(post.picture!),
              ),
            // Nouvelle section pour les commentaires
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icône de commentaire
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    // Redirection vers la page des commentaires
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPostCommentPage(post: post, user: widget.user,),
                      ),
                    );
                  },
                ),
                // Nombre total de commentaires
                Text(
                  'Comments: ${_commentCount(post.id!)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (isCurrentUserPost)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModifPostPage(post: post, user: widget.user,),
                        ),
                      );
                    },
                    child: const Text('Modifier'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
