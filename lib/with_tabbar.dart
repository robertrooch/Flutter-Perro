import 'package:flutter/material.dart';
import 'create_dog_section.dart';
import 'view_dogs_section.dart';

class WithTabBar extends StatefulWidget {
  @override
  _WithTabBarState createState() => _WithTabBarState();
}

class _WithTabBarState extends State<WithTabBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      CreateDogSection(),
      ViewDogsSection(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Perros'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Crear Perro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Ver Perros',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}



