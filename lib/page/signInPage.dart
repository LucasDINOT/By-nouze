import 'package:bynouze/page/signUpPage.dart';
import 'package:flutter/material.dart';
import '../table/user.dart';
import '../database.dart';
import '../home.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _passwordVisible = false;

  void _connexion(BuildContext context) async {
    var mysql = Mysql();
    var conn = await mysql.getConnection();

    var result = await conn.query(
      'SELECT * FROM User WHERE email = ? AND password = ?',
      [emailController.text, passwordController.text],
    );

    print(result);
    await conn.close();

    if (result.isNotEmpty) {
      var userData = result.first;
      User user = User(
        id: userData['Id'],
        email: userData['email'],
        password: userData['password'],
        pseudo: userData['pseudo'],
        firstName: userData['firstname'],
        lastName: userData['lastname'],
        phoneNumber: userData['phoneNumber'],
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(user: user),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Assurez-vous d\'avoir entré les bons identifiants, ou inscrivez-vous'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Connexion"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/bynouze_noslogan.png',
              width: 100.0,
              height: 100.0,
            ),
          ),
          const SizedBox(height: 10.0), // Espacement entre l'image et le texte (ajustable)
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 50.0), // Marge horizontale pour créer l'effet de bordure
              child: const Text(
                'Le forum pour les passionnés de la bière, par des passionnés de la bière',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
          ),
          const SizedBox(height: 100.0), // Espacement entre le texte et le formulaire d'inscription (ajustable)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(25.0), // Bords arrondis
            ),
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: InputBorder.none,
                    hintText: 'Adresse email',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40.0), // Espacement entre le texte et le formulaire d'inscription (ajustable)
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(25.0), // Bords arrondis
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: passwordController,
                    obscureText: !_passwordVisible, // Affiche/masque le mot de passe
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          }
                          );
                        },
                      ),
                      border: InputBorder.none,
                      hintText: 'Mot de passe',
                    ),
                  ),
                ],
              )
          ),

          const SizedBox(height: 100),
          Center(
            child: SizedBox(
              width: 350,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD182),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  minimumSize: const Size(350, 50),
                ),
                onPressed: () {
                  _connexion(context);
                  // Action pour le deuxième bouton
                },

                child: const Text('Connexion', style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500)),
              ),
            ),
          ),// Ajoute un espace vertical entre les boutons

          const SizedBox(height: 40), // Ajoute un espace vertical entre les boutons
          const Center(
            child:
            Text('Je n\'ai pas de compte ?'),
          ),
          GestureDetector(
            onTap: () {
              // Redirigez vers une autre page ici
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (const SignUpPage())),
              );
            },
            child: const Text(
              'Inscription',
              textAlign: TextAlign.center,
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
