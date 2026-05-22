
import 'package:flutter/material.dart';

import '../main/presentation/pages/page1.dart';
import '../main/presentation/pages/page2.dart';
import '../main/presentation/pages/page3.dart';

class CustomBottomNavBar1 extends StatefulWidget {
  @override
  _CustomBottomNavBar1State createState() => _CustomBottomNavBar1State();
}

class _CustomBottomNavBar1State extends State<CustomBottomNavBar1> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Page1(),
    Page2(),
    Page3(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          height: 65,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(offset: Offset(0, -2), blurRadius: 4, color: Colors.black12),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0),
              SizedBox(width: 40), // Пространство для FAB
              _buildNavItem(Icons.person, 'Profile', 2),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() => _selectedIndex = 1),
          child: Icon(Icons.add),
          elevation: 4,
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          Text(label, style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey,
            fontSize: 12,
          )),
        ],
      ),
    );
  }
}