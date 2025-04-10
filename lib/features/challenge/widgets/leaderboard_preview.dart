import 'package:flutter/material.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:solar_icons/solar_icons.dart';

class LeaderboardPreview extends StatelessWidget {
  const LeaderboardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    // This would typically come from an API or controller
    final leaderboardEntries = [
      {'rank': 1, 'name': 'Isabella C.', 'score': 98, 'isCurrentUser': false},
      {'rank': 2, 'name': 'Michael R.', 'score': 95, 'isCurrentUser': false},
      {'rank': 3, 'name': 'David K.', 'score': 93, 'isCurrentUser': false},
      {'rank': 7, 'name': 'Student', 'score': 87, 'isCurrentUser': true},
    ];

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
        children: [
          ...leaderboardEntries.map(
            (entry) => _buildLeaderboardItem(context, entry),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(
    BuildContext context,
    Map<String, dynamic> entry,
  ) {
    final bool isCurrentUser = entry['isCurrentUser'] as bool;
    final int rank = entry['rank'] as int;

    Color? rankColor;
    IconData? rankIcon;

    if (rank == 1) {
      rankColor = const Color(0xFFFFD700); // Gold
      rankIcon = SolarIconsBold.medalRibbon;
    } else if (rank == 2) {
      rankColor = const Color(0xFFC0C0C0); // Silver
      rankIcon = SolarIconsBold.medalRibbon;
    } else if (rank == 3) {
      rankColor = const Color(0xFFCD7F32); // Bronze
      rankIcon = SolarIconsBold.medalRibbon;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppTheme.primaryColor.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color:
                  rankColor?.withOpacity(0.2) ?? Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child:
                  rankIcon != null
                      ? Icon(rankIcon, size: 16, color: rankColor)
                      : Text(
                        '#$rank',
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: rankColor ?? AppTheme.textColor,
                        ),
                      ),
            ),
          ),
          const SizedBox(width: 16),

          // Name
          Expanded(
            child: Text(
              entry['name'] as String,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: isCurrentUser ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),

          // Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:
                  isCurrentUser
                      ? AppTheme.primaryColor.withOpacity(0.2)
                      : AppTheme.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${entry['score']}%',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color:
                    isCurrentUser
                        ? AppTheme.primaryColor
                        : AppTheme.secondaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
