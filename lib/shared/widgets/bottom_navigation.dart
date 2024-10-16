import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:study_mesh/features/groups/presentation/groups_list_screen.dart';
import 'package:study_mesh/features/notes/presentation/notes_screen.dart';
import 'package:study_mesh/features/profile/presentation/profile_screen.dart';
import 'package:study_mesh/features/quizz/presentation/quizz_list_screen.dart';
import 'package:study_mesh/features/tasks/presentation/tasks_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const TasksScreen(),
    NotesScreen(),
    QuizListScreen(),
    GroupListScreen(),
    const ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.graph),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.document),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.activity),
            label: 'Quizz',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.user_3),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.profile),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        onTap: _onItemTapped,
      ),
    );
  }
}
