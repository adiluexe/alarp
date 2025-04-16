import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/practice/widgets/recent_practice_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

class RecentPracticeListScreen extends StatelessWidget {
  const RecentPracticeListScreen({super.key});

  // Mock data for demonstration
  final List<Map<String, dynamic>> mockRecentItems = const [
    {
      'title': 'PA Chest X-ray',
      'region': 'Thorax',
      'lastPracticed': '2 days ago',
      'accuracy': 0.85,
    },
    {
      'title': 'Lateral Skull',
      'region': 'Head & Neck',
      'lastPracticed': '5 days ago',
      'accuracy': 0.72,
    },
    {
      'title': 'AP Abdomen (Supine)',
      'region': 'Abdomen',
      'lastPracticed': '1 week ago',
      'accuracy': 0.91,
    },
    {
      'title': 'Oblique Hand',
      'region': 'Upper Limb',
      'lastPracticed': '10 days ago',
      'accuracy': 0.68,
    },
    // Add more mock items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Recent Practice History'),
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          onPressed: () => context.pop(), // Go back to the previous screen
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: mockRecentItems.length,
        itemBuilder: (context, index) {
          final item = mockRecentItems[index];
          return RecentPracticeItem(
            title: item['title'],
            region: item['region'],
            lastPracticed: item['lastPracticed'],
            accuracy: item['accuracy'],
            // Add onTap later if needed to go to specific practice details
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
    );
  }
}
