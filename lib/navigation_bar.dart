import 'package:flutter/material.dart';
import '../table/user.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final User user;

  const CustomBottomNavigationBar({required this.user});

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

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
    return BottomNavigationBar(
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.blue[500],
      iconSize: 25,
      elevation: 10,
      currentIndex: _selectedIndex,
      items: const [
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
      onTap: _onItemTapped,
    );
  }
}
