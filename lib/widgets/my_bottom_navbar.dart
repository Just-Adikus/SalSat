import 'package:flutter/material.dart';



class MyBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  MyBottomNavigationBar({
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Басты бет',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          label: 'Чаттар',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.control_point_outlined),
          label: 'Жарнама қосу',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined),
          label: 'Таңдаулылар',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Профиль',
        ),
      ],
      currentIndex: widget.currentIndex,
      onTap: widget.onItemTapped,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
    );
  }
}
