import 'package:flutter/material.dart';
import '../table/post.dart';
import '../database.dart';
import '../table/user.dart';

class ModifPostPage extends StatefulWidget {
  final Post post;
  final User user;

  const ModifPostPage({super.key, required this.post, required this.user});

  @override
  _ModifPostPageState createState() => _ModifPostPageState();
}

class _ModifPostPageState extends State<ModifPostPage> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController(); // Contrôleur pour l'URL de l'image

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.post.description;
    // Remplir le champ URL de l'image si une URL existe dans le post
    if (widget.post.picture != null && widget.post.picture!.isNotEmpty) {
      imageUrlController.text = widget.post.picture!;
    }
  }

  void _modifierPost(BuildContext context) async {
    // Vérifier si la description est renseignée
    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer une description pour votre post.'),
        ),
      );
      return;
    }

    // Mise à jour du post dans la base de données
    var mysql = Mysql();
    var conn = await mysql.getConnection();

    // Récupération de l'URL de l'image
    String? imageUrl = imageUrlController.text.isNotEmpty ? imageUrlController.text : null;

    await conn.query(
      'UPDATE Post SET description = ?, picture = ? WHERE id = ?',
      [descriptionController.text, imageUrl, widget.post.id],
    );

    await conn.close();

    Navigator.pushReplacementNamed(context, '/home', arguments: widget.user);

    // Affichage d'un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre post a été modifié avec succès.'),
      ),
    );
  }

  void _supprimerPost(BuildContext context) async {
    // Supprimer le post dans la base de données
    var mysql = Mysql();
    var conn = await mysql.getConnection();

    // Désactiver les contraintes de clés étrangères
    await conn.query('SET FOREIGN_KEY_CHECKS=0');

    await conn.query(
      'DELETE FROM Post WHERE id = ?',
      [widget.post.id],
    );

    // Réactiver les contraintes de clés étrangères
    await conn.query('SET FOREIGN_KEY_CHECKS=1');

    await conn.close();

    Navigator.pushReplacementNamed(context, '/home', arguments: widget.user);

    // Affichage d'un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre post a été supprimé avec succès.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: descriptionController,
              maxLines: null,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            if (widget.post.picture != null && widget.post.picture!.isNotEmpty) // Afficher le champ URL de l'image si une URL existe
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'URL de l\'image'),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _modifierPost(context),
              child: const Text('Modifier'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _supprimerPost(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Supprimer'),
            ),
          ],
        ),
      ),
    );
  }
}
