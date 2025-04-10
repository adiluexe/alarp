import 'package:flutter/material.dart';
import 'package:alarp/core/navigation/app_bottom_navigation.dart';
import 'package:alarp/features/challenge/views/challenge_screen.dart';
import 'package:alarp/features/home/views/home_screen.dart';
import 'package:alarp/features/learn/views/learn_screen.dart';
import 'package:alarp/features/practice/views/practice_screen.dart';
import 'package:alarp/features/profile/views/profile_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const LearnScreen(),
    const PracticeScreen(),
    const ChallengeScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'ALARP',
    'Learn',
    'Practice',
    'Challenge',
    'Profile',
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex]), elevation: 0),
      body: _screens[_currentIndex],
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}
