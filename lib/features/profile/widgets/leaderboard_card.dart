import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/theme/app_theme.dart';
// Import the type definition for leaderboard entries
import '../../../data/repositories/profile_repository.dart';

class LeaderboardCard extends ConsumerWidget {
  final int? currentUserRank;
  final List<LeaderboardEntry> topUsers;

  const LeaderboardCard({
    super.key,
    this.currentUserRank,
    required this.topUsers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final bool isCurrentUserInTopList = topUsers.any(
      (entry) => entry.rank == currentUserRank && currentUserRank != null,
    );

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          children: [
            if (topUsers.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  'No scores submitted yet today!',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topUsers.length,
                itemBuilder: (context, index) {
                  final entry = topUsers[index];
                  final isCurrentUser = entry.rank == currentUserRank;
                  return _buildLeaderboardTile(
                    context,
                    rank: entry.rank,
                    username: entry.username,
                    score: entry.score,
                    isCurrentUser: isCurrentUser,
                  );
                },
                separatorBuilder:
                    (context, index) => Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                      indent: 16,
                      endIndent: 16,
                    ),
              ),
            // Show current user's rank separately if they are not in the top list
            // but their rank is available
            if (currentUserRank != null && !isCurrentUserInTopList)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    Divider(height: 1, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(
                      "Your Rank Today",
                      style: textTheme.labelMedium?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '#$currentUserRank',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    // Optionally, fetch and display the user's score here too
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardTile(
    BuildContext context, {
    required int rank,
    required String username,
    required int score,
    required bool isCurrentUser,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final rankColor =
        rank == 1
            ? Colors.amber.shade700
            : rank == 2
            ? Colors.grey.shade500
            : rank == 3
            ? Colors.brown.shade400
            : AppTheme.textColor.withOpacity(0.8);

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      leading: SizedBox(
        width: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (rank <= 3)
              Icon(
                SolarIconsBold.medalStar, // Use a medal icon for top 3
                color: rankColor,
                size: 20,
              )
            else
              Text(
                '#$rank',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: rankColor,
                ),
              ),
          ],
        ),
      ),
      title: Text(
        username,
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
          color: isCurrentUser ? AppTheme.primaryColor : AppTheme.textColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        '$score',
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: isCurrentUser ? AppTheme.primaryColor : AppTheme.textColor,
        ),
      ),
      tileColor: isCurrentUser ? AppTheme.primaryColor.withOpacity(0.1) : null,
      shape:
          isCurrentUser
              ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
              : null,
    );
  }
}
