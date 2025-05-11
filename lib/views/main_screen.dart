import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:my_flutter_app/views/chatBot_screen.dart';
import 'package:my_flutter_app/views/prediction_screen.dart';
import 'package:my_flutter_app/views/social_screen.dart';
import 'package:my_flutter_app/views/user_screen.dart';
import 'package:my_flutter_app/views/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PredictionScreen(),
    const ChatBotScreen(),
    const SocialScreen(),
    const UserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.white12,
        animationDuration: const Duration(milliseconds: 350),
        height: 60,
        index: _selectedIndex,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.camera, size: 30, color: Colors.white),
          Icon(Icons.smart_toy, size: 30, color: Colors.white),
          Icon(Icons.explore, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}