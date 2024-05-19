import 'package:flutter/material.dart';
import 'table/user.dart';
import 'table/post.dart';
import 'table/comment.dart';
import 'navigation_bar.dart';
import 'database.dart';
import 'page/modif_post_page.dart';
import 'page/view_post_comment_page.dart';
import 'page/modif_profil.dart'; // Import de la page de modification de profil
import 'page/signInPage.dart'; // Import de la page de connexion

class ProfilPage extends StatefulWidget {
  final User user;

  const ProfilPage({super.key, required this.user});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late List<Post> _userPosts = [];
  late List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _fetchUserPosts();
    _fetchComments();
  }

  Future<void> _fetchUserPosts() async {
    var mysql = Mysql();
    var conn = await mysql.getConnection();

    var result = await conn.query(
      'SELECT * FROM Post WHERE id_user = ? ORDER BY date DESC',
      [widget.user.id],
    );

    await conn.close();

    setState(() {
      _userPosts = result.map((row) {
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

  // Fonction pour rafraîchir les données de l'utilisateur après la modification du profil
  Future<void> _refreshUserData() async {
    await _fetchUserPosts();
    // Vous pouvez également appeler _fetchComments() ici si nécessaire

    // Réactualiser toute l'application en remplaçant la page de profil
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilPage(user: widget.user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('ByNouze'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    // Placeholder pour l'icône de l'utilisateur
                    child: Icon(Icons.account_circle, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pseudo: ${widget.user.pseudo}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Email: ${widget.user.email}'),
                  const SizedBox(height: 8),
                  Text('Nom: ${widget.user.lastName}'),
                  const SizedBox(height: 8),
                  Text('Prénom: ${widget.user.firstName}'),
                  const SizedBox(height: 8),
                  Text('Numéro de téléphone: ${widget.user.phoneNumber}'),
                  const SizedBox(height: 16),
                  if (widget.user.id == widget.user.id)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModifProfilPage(user: widget.user),
                          ),
                        ).then((value) {
                          // Rafraîchir la page de profil après la modification
                          if (value == true) {
                            _refreshUserData();
                          }
                        });
                      },
                      child: const Text('Modifier profil'),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Clear le cache de l'utilisateur
                      // Placeholder pour l'action de déconnexion
                      // Rediriger vers la page de connexion
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInPage()),
                        (route) => false, // Empêche l'utilisateur de revenir en arrière avec le bouton de retour
                      );
                    },
                    child: const Text('Déconnexion'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _userPosts.length,
              itemBuilder: (context, index) {
                return _buildPostCard(_userPosts[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(user: widget.user),
    );
  }

  Widget _buildPostCard(Post post) {
    bool isCurrentUserPost = post.idUser == widget.user.id;

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Posté par: ${widget.user.pseudo}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text('Date: ${post.date}'),
            const SizedBox(height: 5),
            Text('Description: ${post.description}'),
            // Afficher la photo si elle existe
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
