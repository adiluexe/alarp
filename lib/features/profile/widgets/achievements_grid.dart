import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';

class AchievementsGrid extends StatelessWidget {
  const AchievementsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock achievements data
    final achievements = [
      {
        'title': 'Skull Master',
        'description': 'Completed all head projections with 90%+ accuracy',
        'icon': SolarIconsBold.bones,
        'color': const Color(0xFFEB6B9D),
        'unlocked': true,
      },
      {
        'title': 'Perfect Week',
        'description': 'Completed at least one challenge every day for a week',
        'icon': SolarIconsBold.calendar,
        'color': AppTheme.primaryColor,
        'unlocked': true,
      },
      {
        'title': 'Accuracy Master',
        'description': 'Achieved 95%+ accuracy on 10 consecutive challenges',
        'icon': SolarIconsBold.target,
        'color': AppTheme.accentColor,
        'unlocked': true,
      },
      {
        'title': 'Thorax Expert',
        'description': 'Mastered all thorax projections',
        'icon': SolarIconsBold.heart,
        'color': const Color(0xFF5B93EB),
        'unlocked': false,
      },
      {
        'title': 'Speed Demon',
        'description': 'Completed a challenge in under 30 seconds',
        'icon': SolarIconsBold.stopwatch,
        'color': const Color(0xFFFFAA33),
        'unlocked': false,
      },
      {
        'title': 'Full Mastery',
        'description': 'Completed all projections with at least 85% accuracy',
        'icon': SolarIconsBold.diploma,
        'color': const Color(0xFF53C892),
        'unlocked': false,
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
