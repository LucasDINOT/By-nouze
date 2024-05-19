import 'package:flutter/material.dart';
import '../table/user.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final User user;

  const CustomBottomNavigationBar({super.key, required this.user});

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;


  get index => null;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home', arguments: widget.user);
        break;
      case 1:
        Navigator.pushNamed(context, '/post', arguments: widget.user);
        break;
      case 2:
        Navigator.pushNamed(context, '/profil', arguments: widget.user);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: index.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white38, width: 1), // Add a border to the nav
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF7DBBD1),
          unselectedItemColor: Colors.grey,
          // Make inactive items grey
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}