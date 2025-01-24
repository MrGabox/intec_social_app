import 'package:flutter/material.dart';
import 'package:intec_social_app/views/screens/nav_screens/feed_screen.dart';
import 'package:intec_social_app/views/screens/nav_screens/post_screen.dart';
import 'package:intec_social_app/views/screens/nav_screens/profile_screen.dart';
import 'package:intec_social_app/views/screens/nav_screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    FeedScreen(), // Pantalla de feed
    SearchScreen(), // Pantalla de búsqueda
    PostScreen(), // Pantalla para publicar contenido
    ProfileScreen(), // Pantalla de perfil
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Cargar la pantalla seleccionada
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap, // Cambiar de pantalla
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Publicar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
