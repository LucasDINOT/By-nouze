import 'package:bynouze/page/welcomePage.dart';
import 'package:flutter/material.dart';
import '/page/signInPage.dart';
import '/home.dart';
import '/profil.dart';
import '/page/post_page.dart';
import '/table/user.dart'; // Importer la classe User

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFF0DA),
        useMaterial3: true,
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/connexion': (context) => const SignInPage(),
        '/home': (context) => HomePage(user: ModalRoute.of(context)!.settings.arguments as User),
        '/profil': (context) => ProfilPage(user: ModalRoute.of(context)!.settings.arguments as User),
        '/post': (context) => PostPage(user: ModalRoute.of(context)!.settings.arguments as User),
      },
    );
  }
}
