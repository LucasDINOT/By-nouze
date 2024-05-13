import 'package:flutter/material.dart';
import './table/user.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome ${user.firstName} ${user.lastName}!'),
            SizedBox(height: 16),
            Text('Email: ${user.email}'),
            Text('Pseudo: ${user.pseudo}'),
            Text('Phone Number: ${user.phoneNumber}'),
          ],
        ),
      ),
    );
  }
}
