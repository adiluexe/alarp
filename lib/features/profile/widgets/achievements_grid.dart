import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';

class AchievementsGrid extends StatelessWidget {
  final int streak;
  final int lessonsCompleted;
  final double accuracy;
  final int totalTimeSeconds;

  const AchievementsGrid({
    Key? key,
    required this.streak,
    required this.lessonsCompleted,
    required this.accuracy,
    required this.totalTimeSeconds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define achievements logic
    final achievements = [
      // Streak Badges
      {
        'title': 'Streak Starter',
        'description': 'Reach a 3-day streak',
        'icon': SolarIconsBold.fire,
        'color': const Color(0xFFFFAA33),
        'unlocked': streak >= 3,
      },
      {
        'title': 'Week Warrior',
        'description': 'Reach a 7-day streak',
        'icon': SolarIconsBold.calendar,
        'color': const Color(0xFFFF5500),
        'unlocked': streak >= 7,
      },

      // Lesson Badges
      {
        'title': 'Novice',
        'description': 'Complete 5 lessons',
        'icon': SolarIconsBold.notebook,
        'color': const Color(0xFF5B93EB),
        'unlocked': lessonsCompleted >= 5,
      },
      {
        'title': 'Scholar',
        'description': 'Complete 10 lessons',
        'icon': SolarIconsBold.diploma,
        'color': const Color(0xFF9474DE),
        'unlocked': lessonsCompleted >= 10,
      },

      // Accuracy Badges
      {
        'title': 'Sharpshooter',
        'description': 'Achieve 80% average accuracy',
        'icon': SolarIconsBold.target,
        'color': const Color(0xFF53C892),
        'unlocked': accuracy >= 80.0,
      },
      {
        'title': 'Precision Master',
        'description': 'Achieve 90% average accuracy',
        'icon': SolarIconsBold.verifiedCheck,
        'color': const Color(0xFFEB6B9D),
        'unlocked': accuracy >= 90.0,
      },

      // Time Badges
      {
        'title': 'Dedicated',
        'description': 'Study for 1 hour total',
        'icon': SolarIconsBold.clockCircle,
        'color': const Color(0xFF4BC8EB),
        'unlocked': totalTimeSeconds >= 3600,
      },
      {
        'title': 'Expert',
        'description': 'Study for 5 hours total',
        'icon': SolarIconsBold.star,
        'color': const Color(0xFFFFD700),
        'unlocked': totalTimeSeconds >= 18000,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final bool unlocked = achievement['unlocked'] as bool;
        final Color color = achievement['color'] as Color;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Badge icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: unlocked ? color : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  achievement['icon'] as IconData,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),

              // Badge title
              Text(
                achievement['title'] as String,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: unlocked ? AppTheme.textColor : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Badge description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  achievement['description'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: unlocked ? null : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Locked indicator
              if (!unlocked)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        SolarIconsOutline.lock,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Locked',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
