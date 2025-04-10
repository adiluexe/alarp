import 'package:flutter/material.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:solar_icons/solar_icons.dart';

class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final String difficulty;
  final String timeLimit;
  final int participants;
  final bool isActive;
  final String? yourScore;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.timeLimit,
    required this.participants,
    required this.isActive,
    this.yourScore,
  });

  @override
  Widget build(BuildContext context) {
    Color difficultyColor;
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        difficultyColor = Colors.green;
        break;
      case 'intermediate':
        difficultyColor = AppTheme.primaryColor;
        break;
      case 'advanced':
        difficultyColor = AppTheme.accentColor;
        break;
      default:
        difficultyColor = AppTheme.primaryColor;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'Chillax',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: difficultyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  difficulty,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: difficultyColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Description
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              _buildStatItem(
                context,
                SolarIconsOutline.stopwatch,
                timeLimit,
                'Time Limit',
              ),
              const SizedBox(width: 16),
              _buildStatItem(
                context,
                SolarIconsOutline.usersGroupTwoRounded,
                '$participants',
                'Participants',
              ),
              if (yourScore != null) ...[
                const SizedBox(width: 16),
                _buildStatItem(
                  context,
                  SolarIconsOutline.medalRibbon,
                  yourScore!,
                  'Your Score',
                ),
              ],
              const Spacer(),

              // Button
              if (isActive)
                ElevatedButton(
                  onPressed: () {
                    // Navigate to challenge
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Start'),
                )
              else
                OutlinedButton(
                  onPressed: () {
                    // View challenge details
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: BorderSide(color: AppTheme.primaryColor),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('View'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppTheme.textColor.withOpacity(0.6)),
            const SizedBox(width: 6),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
