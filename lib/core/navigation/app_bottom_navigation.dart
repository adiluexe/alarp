import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTapped; // Ensure this signature

  const AppBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabTapped, // This should correctly pass the index
      type: BottomNavigationBarType.fixed, // Ensures all items are visible
      backgroundColor: Colors.white,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: AppTheme.textColor.withOpacity(0.6),
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      elevation: 8.0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(SolarIconsOutline.homeSmileAngle),
          activeIcon: Icon(SolarIconsBold.homeSmileAngle),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(SolarIconsOutline.notebook),
          activeIcon: Icon(SolarIconsBold.notebook),
          label: 'Learn',
        ),
        BottomNavigationBarItem(
          icon: Icon(SolarIconsOutline.documentAdd),
          activeIcon: Icon(SolarIconsBold.documentAdd),
          label: 'Practice',
        ),
        BottomNavigationBarItem(
          icon: Icon(SolarIconsOutline.medalRibbonStar),
          activeIcon: Icon(SolarIconsBold.medalRibbonStar),
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
