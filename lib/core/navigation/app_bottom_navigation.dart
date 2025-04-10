import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTabTapped,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(SolarIconsOutline.home),
          activeIcon: Icon(SolarIconsBold.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(SolarIconsOutline.bookBookmark),
          activeIcon: Icon(SolarIconsBold.bookBookmark),
          label: 'Learn',
        ),
        BottomNavigationBarItem(
          icon: Icon(SolarIconsOutline.compassSquare),
          activeIcon: Icon(SolarIconsBold.compassSquare),
          label: 'Practice',
        ),
        BottomNavigationBarItem(
          icon: Icon(SolarIconsOutline.medalStar),
          activeIcon: Icon(SolarIconsBold.medalStar),
          label: 'Challenge',
        ),
        BottomNavigationBarItem(
          icon: Icon(SolarIconsOutline.user),
          activeIcon: Icon(SolarIconsBold.user),
          label: 'Profile',
        ),
      ],
    );
  }
}
