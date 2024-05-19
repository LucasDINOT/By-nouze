import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../table/user.dart';
import '../navigation_bar.dart'; // Import du widget de barre de navigation
import '../database.dart';

class PostPage extends StatelessWidget {
  final User user;

  const PostPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return _PostPageStateful(user: user);
  }
}

class _PostPageStateful extends StatefulWidget {
  final User user;

  const _PostPageStateful({required this.user});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<_PostPageStateful> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController(); // Contrôleur pour l'URL de l'image
  File? _image;

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _getImageFromUrl(String imageUrl) async {
    // Utilisation de la bibliothèque Dio pour télécharger l'image depuis l'URL
    var response = await Dio().get(imageUrl, options: Options(responseType: ResponseType.bytes));
    
    setState(() {
      _image = File.fromRawPath(response.data);
    });
  }

  void _submitPost(BuildContext context) async {
    // Vérifier si la description est renseignée
    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer une description pour votre post.'),
        ),
      );
      return;
    }

    // Enregistrement du post dans la base de données
    var mysql = Mysql();
    var conn = await mysql.getConnection();

    // Récupération de l'URL de l'image
    String? imageUrl = imageUrlController.text.isNotEmpty ? imageUrlController.text : null;

    // Conversion de l'image en base64 pour la stocker dans la base de données
    List<int>? imageBytes;
    if (_image != null) {
      imageBytes = await _image!.readAsBytes();
    }

    await conn.query(
      'INSERT INTO Post (id_user, description, picture) VALUES (?, ?, ?)',
      [
        widget.user.id, // Utilisation de l'id de l'utilisateur passé en paramètre
        descriptionController.text,
        imageUrlController.text, // Enregistrement de l'image comme tableau d'octets
      ],
    );

    await conn.close();

    // Affichage d'un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre post a été publié avec succès.'),
      ),
    );

    // Effacer le champ de description, l'image sélectionnée et l'URL après la publication du post
    setState(() {
      descriptionController.clear();
      imageUrlController.clear();
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ecris ton poste'),
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
            TextFormField(
              controller: imageUrlController,
              decoration: const InputDecoration(labelText: 'URL de l\'image'), // Champ pour saisir l'URL de l'image
            ),
            if (_image != null) SizedBox(height: 16, child: Image.file(_image!)), // Affichage de l'image sélectionnée
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _submitPost(context),
              child: const Text('Publier'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(user: widget.user), // Ajout de la barre de navigation
    );
  }
}
