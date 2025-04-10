import 'package:flutter/material.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/features/practice/widgets/recent_practice_item.dart';
import 'package:alarp/features/practice/widgets/region_carousel_card.dart';
import 'package:alarp/features/practice/widgets/difficulty_card.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Practice Lab',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontFamily: 'Chillax',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hands-on radiographic positioning practice',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Recent practice section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recently Practiced',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontFamily: 'Chillax',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            SolarIconsOutline.clockCircle,
                            size: 18,
                          ),
                          label: const Text('View All'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const RecentPracticeItem(
                      title: 'PA Chest X-ray',
                      region: 'Thorax',
                      lastPracticed: '2 days ago',
                      accuracy: 0.85,
                    ),
                    const SizedBox(height: 12),
                    const RecentPracticeItem(
                      title: 'Lateral Skull',
                      region: 'Head & Neck',
                      lastPracticed: '5 days ago',
                      accuracy: 0.72,
                    ),
                    const SizedBox(height: 24),
                    Container(height: 1, color: Colors.grey.withOpacity(0.2)),
                    const SizedBox(height: 24),
                    Text(
                      'Select Body Region',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: 'Chillax',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose a region to practice positioning techniques',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Body regions horizontal carousel
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: const [
                    RegionCarouselCard(
                      title: 'Head & Neck',
                      emoji: '🧠',
                      positionCount: 18,
                      backgroundColor: Color(0xFFEB6B9D),
                    ),
                    RegionCarouselCard(
                      title: 'Thorax',
                      emoji: '🫁',
                      positionCount: 12,
                      backgroundColor: Color(0xFF5B93EB),
                    ),
                    RegionCarouselCard(
                      title: 'Abdomen & Pelvis',
                      emoji: '🫃',
                      positionCount: 15,
                      backgroundColor: Color(0xFF53C892),
                    ),
                    RegionCarouselCard(
                      title: 'Upper Extremity',
                      emoji: '💪',
                      positionCount: 20,
                      backgroundColor: Color(0xFFFFAA33),
                    ),
                    RegionCarouselCard(
                      title: 'Lower Extremity',
                      emoji: '🦵',
                      positionCount: 22,
                      backgroundColor: Color(0xFF9474DE),
                    ),
                    RegionCarouselCard(
                      title: 'Spine',
                      emoji: '🦴',
                      positionCount: 14,
                      backgroundColor: Color(0xFF4BC8EB),
                    ),
                  ],
                ),
              ),
            ),

            // Difficulty-based practice options
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Practice by Difficulty',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: 'Chillax',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const DifficultyCard(
                      title: 'Beginner Practice',
                      description:
                          'Basic positioning techniques with guided assistance',
                      icon: SolarIconsOutline.stars,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    const DifficultyCard(
                      title: 'Intermediate Practice',
                      description: 'Standard positioning with minimal guidance',
                      icon: SolarIconsOutline.star,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 12),
                    const DifficultyCard(
                      title: 'Advanced Practice',
                      description:
                          'Complex positioning scenarios for experienced users',
                      icon: SolarIconsOutline.starFall,
                      color: AppTheme.accentColor,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
