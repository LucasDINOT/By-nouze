import 'package:bynouze/page/signInPage.dart';
import 'package:bynouze/page/signUpPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page d\'accueil',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFF0DA),
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();
  }



  @override
  void dispose() {
    super.dispose();
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 8.0, top: 35.0, right: 8.0, bottom: 8.0),

              child: Image.asset(
                'assets/images/bynouze_noslogan.png',
                width: 100, // Réglez la largeur de votre logo
                height: 100, // Réglez la hauteur de votre logo
              ),
            ),
          ),
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Image.asset(
                        'assets/images/superbinz.png',
                        width: 400,
                        height: 400
                    ),
                  ),
                  const SizedBox(height: 30), // Ajoute un espace vertical entre les boutons

                  const Text(
                    'Superbinz te souhaite la bienvenue !',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10), // Ajoute un espace vertical entre le texte et les boutons
                  const Text(
                    'Ici on ne subit pas la pression, on la boit !',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30), // Ajoute un espace vertical entre le texte et les boutons
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD182),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      minimumSize: const Size(350, 50),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInPage()),
                      );
                      },
                    child: const Text('Se connecter', style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 30), // Ajoute un espace vertical entre les boutons
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFFFF),
                      foregroundColor: const Color(0xFFFFD182),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: const BorderSide(color: Colors.black),
                      ),
                      minimumSize: const Size(350, 50),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                      // Action pour le deuxième bouton
                    },
                    child: const Text('S\'inscrire', style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500)),
                  ),

                ],
              )
          )
        ],
      ),
    );
  }
}

