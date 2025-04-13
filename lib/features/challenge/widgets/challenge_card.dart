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
  final VoidCallback? onTap;
  final Gradient? gradientBackground; // Add gradient parameter

  const ChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.timeLimit,
    required this.participants,
    this.isActive = false,
    this.yourScore,
    this.onTap,
    this.gradientBackground, // Initialize gradient parameter
  });

  @override
  Widget build(BuildContext context) {
    // Determine text color based on background
    final bool useDarkText =
        gradientBackground ==
        null; // Use dark text on white/default, light on gradient
    final Color textColor = useDarkText ? AppTheme.textColor : Colors.white;
    final Color secondaryTextColor =
        useDarkText
            ? AppTheme.textColor.withOpacity(0.7)
            : Colors.white.withOpacity(0.8);
    final Color iconColor = useDarkText ? AppTheme.primaryColor : Colors.white;
    final Color chipBackgroundColor =
        useDarkText
            ? AppTheme.primaryColor.withOpacity(0.1)
            : Colors.white.withOpacity(0.2);
    final Color chipTextColor =
        useDarkText ? AppTheme.primaryColor : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Apply gradient if provided, otherwise use white
          gradient: gradientBackground,
          color: gradientBackground == null ? Colors.white : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // Adjust shadow color based on background
              color: (gradientBackground == null
                      ? Colors.black
                      : AppTheme.primaryColor)
                  .withOpacity(0.1),
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
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor, // Use adjusted text color
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: chipBackgroundColor, // Use adjusted chip color
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          SolarIconsBold.play,
                          size: 14,
                          color: chipTextColor,
                        ), // Use adjusted chip text color
                        const SizedBox(width: 4),
                        Text(
                          'Active',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                            color: chipTextColor,
                            fontWeight: FontWeight.bold,
                          ), // Use adjusted chip text color
                        ),
                      ],
                    ),
                  ),
                if (!isActive && yourScore != null)
                  Text(
                    'Score: $yourScore',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor, // Use adjusted text color
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: secondaryTextColor,
              ), // Use adjusted secondary text color
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(
                  context,
                  icon: SolarIconsOutline.chartSquare,
                  text: difficulty,
                  iconColor: iconColor, // Use adjusted icon color
                  backgroundColor:
                      chipBackgroundColor, // Use adjusted chip color
                  textColor: chipTextColor, // Use adjusted chip text color
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  context,
                  icon: SolarIconsOutline.clockCircle,
                  text: timeLimit,
                  iconColor: iconColor, // Use adjusted icon color
                  backgroundColor:
                      chipBackgroundColor, // Use adjusted chip color
                  textColor: chipTextColor, // Use adjusted chip text color
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  context,
                  icon: SolarIconsOutline.usersGroupRounded,
                  text: '$participants',
                  iconColor: iconColor, // Use adjusted icon color
                  backgroundColor:
                      chipBackgroundColor, // Use adjusted chip color
                  textColor: chipTextColor, // Use adjusted chip text color
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color iconColor,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
