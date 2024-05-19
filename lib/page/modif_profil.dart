import 'package:flutter/material.dart';
import '../table/user.dart';
import '../database.dart';
import '../page/signInPage.dart'; // Import de la page de connexion

class ModifProfilPage extends StatefulWidget {
  final User user;

  const ModifProfilPage({super.key, required this.user});

  @override
  _ModifProfilPageState createState() => _ModifProfilPageState();
}

class _ModifProfilPageState extends State<ModifProfilPage> {
  late TextEditingController _pseudoController;
  late TextEditingController _emailController;
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _telephoneController;

  @override
  void initState() {
    super.initState();
    _pseudoController = TextEditingController(text: widget.user.pseudo);
    _emailController = TextEditingController(text: widget.user.email);
    _nomController = TextEditingController(text: widget.user.lastName);
    _prenomController = TextEditingController(text: widget.user.firstName);
    _telephoneController = TextEditingController(text: widget.user.phoneNumber.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _pseudoController,
              decoration: const InputDecoration(labelText: 'Pseudo'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextFormField(
              controller: _prenomController,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            TextFormField(
              controller: _telephoneController,
              decoration: const InputDecoration(labelText: 'Numéro de téléphone'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog(context);
              },
              child: const Text('Modifier le profil'),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Pour prendre en compte vos modifications, vous allez être déconnecté."),
          actions: [
            TextButton(
              onPressed: () {
                _disconnectUserAndNavigateToLogin(context);
              },
              child: const Text("Continuer"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Annuler"),
            ),
          ],
        );
      },
    );
  }

  void _disconnectUserAndNavigateToLogin(BuildContext context) async {
    // Mise à jour des informations dans la base de données
    var mysql = Mysql();
    var conn = await mysql.getConnection();

    try {
      await conn.query(
        'UPDATE User SET pseudo = ?, email = ?, lastname = ?, firstname = ?, phoneNumber = ? WHERE id = ?',
        [
          _pseudoController.text,
          _emailController.text,
          _nomController.text,
          _prenomController.text,
          int.parse(_telephoneController.text),
          widget.user.id,
        ],
      );

      // Affichage d'un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Votre profil a été modifié avec succès.'),
        ),
      );

      // Déconnexion de l'utilisateur et redirection vers la page de connexion
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
        (route) => false, // Empêche l'utilisateur de revenir en arrière avec le bouton de retour
      );
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Une erreur s\'est produite lors de la modification du profil.'),
        ),
      );
    } finally {
      await conn.close();
    }
  }
}
