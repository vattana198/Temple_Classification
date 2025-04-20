import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const NavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFA87E62),
      currentIndex: currentIndex,
      onTap: onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 30),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore, size: 30),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            width: 32,
            child: ImageIcon(
              AssetImage('assets/images/saved.png'),
              size: 32,
            ),
          ),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 30, color: Color(0xFF6B7280)),
          label: 'Profile',
        ),
      ],
    );
  }
}
