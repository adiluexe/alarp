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
  final VoidCallback? onTap; // Add this line

  const ChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.timeLimit,
    required this.participants,
    required this.isActive,
    this.yourScore,
    this.onTap, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    final Color difficultyColor = _getDifficultyColor(difficulty);

    // Wrap with InkWell for tap functionality
    return InkWell(
      onTap: onTap, // Use the onTap callback
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Difficulty Chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: difficultyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    difficulty,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: difficultyColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Time Limit
                Row(
                  children: [
                    Icon(
                      SolarIconsOutline.clockCircle,
                      size: 16,
                      color: AppTheme.textColor.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timeLimit,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            // Description
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textColor.withOpacity(0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            // Footer row (Participants/Score and Button)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Participants or Score
                Row(
                  children: [
                    Icon(
                      isActive
                          ? SolarIconsOutline.usersGroupRounded
                          : SolarIconsOutline.checkCircle,
                      size: 18,
                      color: AppTheme.textColor.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isActive
                          ? '$participants participants'
                          : 'Your Score: ${yourScore ?? 'N/A'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                // Start/View Button (only show if onTap is provided)
                if (onTap != null)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey[400],
                    size: 24,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
