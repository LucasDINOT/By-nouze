import 'package:bynouze/page/signInPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../table/user.dart';
import '../database.dart';
import '../home.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pseudoController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  bool _passwordVisible = false;

  void _inscription(BuildContext context) async {
  User newUser = User(
    email: emailController.text,
    password: passwordController.text,
    pseudo: pseudoController.text,
    firstName: firstNameController.text,
    lastName: lastNameController.text,
    phoneNumber: int.parse(phoneNumberController.text),
  );

  var mysql = Mysql();
  var conn = await mysql.getConnection();

  await conn.query(
    'INSERT INTO User (email, password, pseudo, firstname, lastname, phoneNumber, profilePicture) VALUES (?, ?, ?, ?, ?, ?, ?)',
    [
      newUser.email,
      newUser.password,
      newUser.pseudo,
      newUser.firstName,
      newUser.lastName,
      newUser.phoneNumber,
      newUser.profilePicture,
    ],
  );

  await conn.close();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => HomePage(user: newUser),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Inscription"),
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
          const SizedBox(height: 50.0), // Espacement entre le texte et le formulaire d'inscription (ajustable)
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
          const SizedBox(height: 10.0), // Espacement entre le texte et le formulaire d'inscription (ajustable)
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
          const SizedBox(height: 10.0), // Espacement entre le texte et le formulaire d'inscription (ajustable)
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(25.0), // Bords arrondis
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: pseudoController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.account_circle),
                      border: InputBorder.none,
                      hintText: 'Pseudo',
                    ),
                  ),
                ],
              )
          ),
          const SizedBox(height: 10.0), // Espacement entre le texte et le formulaire d'inscription (ajustable)
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(25.0), // Bords arrondis
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.account_box),
                      border: InputBorder.none,
                      hintText: 'Prénom',
                    ),
                  ),
                ],
              )
          ),
          const SizedBox(height: 10.0), // Espacement entre le texte et le formulaire d'inscription (ajustable)
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(25.0), // Bords arrondis
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.account_box),
                      border: InputBorder.none,
                      hintText: 'Nom',
                    ),
                  ),
                ],
              )
          ),
          const SizedBox(height: 10.0), // Espacement entre le texte et le formulaire d'inscription (ajustable)
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(25.0), // Bords arrondis
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      border: InputBorder.none,
                      hintText: 'Téléphone',
                      counterText: '', // Masque le compteur de longueur de texte
                    ),
                  ),
                ],
              )
          ),
          const SizedBox(height: 50),
          Center(
            child: SizedBox(
              width: 350,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFFFF),
                  foregroundColor: const Color(0xFFFFD182),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  minimumSize: const Size(10, 50),
                ),
                onPressed: () {
                  _inscription(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                  // Action pour le deuxième bouton
                },

                child: const Text('Inscription', style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500)),
              ),
            ),
          ),// Ajoute un espace vertical entre les boutons

          const SizedBox(height: 40), // Ajoute un espace vertical entre les boutons
          const Center(
            child:
            Text('J\'ai déjà un compte ?'),
          ),
          GestureDetector(
            onTap: () {
              // Redirigez vers une autre page ici
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (const SignInPage())),
              );
            },
            child: const Text(
              'Connexion',
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
