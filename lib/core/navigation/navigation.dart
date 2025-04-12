import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:alarp/core/navigation/app_bottom_navigation.dart';
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes

// Modify to accept currentIndex and child
class Navigation extends StatelessWidget {
  final int currentIndex;
  final Widget child; // The screen content provided by GoRouter

  const Navigation({
    required this.currentIndex,
    required this.child,
    super.key,
  });

  // Titles corresponding to the bottom nav indices
  static const List<String> _titles = [
    'ALARP',
    'Learn',
    'Practice',
    'Challenge',
    'Profile',
  ];

  // Routes corresponding to the bottom nav indices
  static const List<String> _routes = [
    AppRoutes.home,
    AppRoutes.learn,
    AppRoutes.practice,
    AppRoutes.challenge,
    AppRoutes.profile,
  ];

  void _onTabTapped(BuildContext context, int index) {
    // Use GoRouter to navigate to the corresponding route
    if (index != currentIndex) {
      context.go(_routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar might be better handled within individual screens or conditionally shown
      // appBar: AppBar(title: Text(_titles[currentIndex]), elevation: 0),
      body: child, // Display the child screen passed by GoRouter
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: currentIndex,
        onTabTapped: (index) => _onTabTapped(context, index), // Pass context
      ),
    );
  }
}
