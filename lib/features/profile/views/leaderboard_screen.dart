import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart'; // Import solar_icons
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/profile/controllers/leaderboard_providers.dart';
import 'package:alarp/data/repositories/profile_repository.dart'; // For LeaderboardEntry
import 'package:alarp/features/profile/widgets/leaderboard_card.dart'; // Reuse the tile logic
import 'package:go_router/go_router.dart'; // Import go_router

// Provider to fetch the top 25 leaderboard entries
final fullLeaderboardProvider =
    FutureProvider.family<List<LeaderboardEntry>, String>((
      ref,
      challengeId,
    ) async {
      try {
        final repository = ref.watch(profileRepositoryProvider);
        // Fetch top 25 entries
        final leaderboardData = await repository.getDailyLeaderboard(
          challengeId,
          limit: 25,
        );
        return leaderboardData;
      } catch (e, stackTrace) {
        rethrow;
      }
    }, name: 'fullLeaderboardProvider');

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  // TODO: Accept challengeId as a parameter for flexibility
  final String challengeId = 'upper_extremities_10rounds'; // Default for now

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(fullLeaderboardProvider(challengeId));
    // Optionally watch user rank if needed on this screen too
    // final userRankAsync = ref.watch(userDailyRankProvider(challengeId));
    // final userRank = userRankAsync.asData?.value?.rank;

    // Format the title nicely
    final String formattedTitle = challengeId
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          onPressed: () => context.pop(),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: RefreshIndicator(
        onRefresh:
            () => ref.refresh(fullLeaderboardProvider(challengeId).future),
        color: AppTheme.primaryColor,
        child: leaderboardAsync.when(
          data: (leaderboardData) {
            if (leaderboardData.isEmpty) {
              return const Center(
                child: Text('No scores submitted yet today!'),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: leaderboardData.length,
              itemBuilder: (context, index) {
                final entry = leaderboardData[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: LeaderboardCard(
                      topUsers: [entry],
                    )._buildLeaderboardTile(
                      context,
                      rank: entry.rank,
                      username: entry.username,
                      score: entry.score,
                      isCurrentUser: false,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error loading leaderboard: $error',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
        ),
      ),
    );
  }
}

// --- Helper Extension Method (Consider moving to LeaderboardCard file) ---
// This is a workaround to access the private method. A better approach would be
// to extract _buildLeaderboardTile into a public static method or a separate widget.
extension LeaderboardTileBuilder on LeaderboardCard {
  Widget _buildLeaderboardTile(
    BuildContext context, {
    required int rank,
    required String username,
    required int score,
    required bool isCurrentUser,
  }) {
    // Copy the implementation from LeaderboardCard._buildLeaderboardTile
    final textTheme = Theme.of(context).textTheme;
    final rankColor =
        rank == 1
            ? Colors.amber.shade700
            : rank == 2
            ? Colors.grey.shade500
            : rank == 3
            ? Colors.brown.shade400
            // Use withAlpha for deprecated withOpacity
            : AppTheme.textColor.withAlpha((0.8 * 255).round());

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
      // Use withAlpha for deprecated withOpacity
      tileColor:
          isCurrentUser
              ? AppTheme.primaryColor.withAlpha((0.1 * 255).round())
              : null,
      shape:
          isCurrentUser
              ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
              : null,
    );
  }
}
