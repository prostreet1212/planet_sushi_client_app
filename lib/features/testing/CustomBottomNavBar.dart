//пустой item под fab
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Container(
        color: Colors.red,
        child: const Center(child: Text('Home Screen', style: TextStyle(fontSize: 24)))),
    Container(
        color: Colors.yellow,
        child: const Center(child: Text('FAB Screen', style: TextStyle(fontSize: 24)))),
    Container(
        color: Colors.green,
        child: const Center(child: Text('Profile Screen', style: TextStyle(fontSize: 24)))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar://CustomBottomNavBar1(),

      Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: SizedBox.shrink(), // Пустая иконка для FAB
                label: 'Корзина',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
          Positioned(
            top: -28, // Поднимаем FAB над BottomNavigationBar
            child: FloatingActionButton(
              onPressed: () => _onItemTapped(1),
              elevation: 4, // Индекс средней вкладки
              child: const Icon(Icons.one_k_plus),
            ),
          ),
        ],
      ),
    );
  }
}