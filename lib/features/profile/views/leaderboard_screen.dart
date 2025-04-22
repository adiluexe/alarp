import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart'; // Import solar_icons
import 'package:alarp/core/theme/app_theme.dart';
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

// Provider to fetch the all-time leaderboard entries
final allTimeLeaderboardProvider = FutureProvider.family<
  List<LeaderboardEntry>,
  String
>((ref, challengeId) async {
  try {
    final repository = ref.watch(profileRepositoryProvider);
    // Fetch all-time entries
    final leaderboardData = await repository.getAllTimeLeaderboard(challengeId);
    return leaderboardData;
  } catch (e, stackTrace) {
    rethrow;
  }
}, name: 'allTimeLeaderboardProvider');

// Use a StateProvider to hold the selected leaderboard type
final leaderboardTypeProvider = StateProvider<LeaderboardType>(
  (ref) => LeaderboardType.today,
);

enum LeaderboardType { today, allTime }

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  // TODO: Accept challengeId as a parameter for flexibility
  final String challengeId = 'upper_extremities_10rounds'; // Default for now

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardType = ref.watch(leaderboardTypeProvider);
    final leaderboardAsync =
        leaderboardType == LeaderboardType.today
            ? ref.watch(fullLeaderboardProvider(challengeId))
            : ref.watch(allTimeLeaderboardProvider(challengeId));

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<LeaderboardType>(
              segments: const [
                ButtonSegment(
                  value: LeaderboardType.today,
                  label: Text('Today'),
                  icon: Icon(SolarIconsBold.calendar),
                ),
                ButtonSegment(
                  value: LeaderboardType.allTime,
                  label: Text('All Time'),
                  icon: Icon(
                    SolarIconsBold.medalRibbonStar,
                  ), // Use a valid icon
                ),
              ],
              selected: {leaderboardType},
              onSelectionChanged: (newSelection) {
                ref.read(leaderboardTypeProvider.notifier).state =
                    newSelection.first;
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Colors.white, // Use a valid color for surface
                ),
                foregroundColor: WidgetStateProperty.all(AppTheme.primaryColor),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                if (leaderboardType == LeaderboardType.today) {
                  ref.invalidate(fullLeaderboardProvider(challengeId));
                } else {
                  ref.invalidate(allTimeLeaderboardProvider(challengeId));
                }
              },
              color: AppTheme.primaryColor,
              child: leaderboardAsync.when(
                data: (leaderboardData) {
                  if (leaderboardData.isEmpty) {
                    return Center(
                      child: Text(
                        leaderboardType == LeaderboardType.today
                            ? 'No scores submitted yet today!'
                            : 'No scores submitted yet!',
                      ),
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
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.surfaceContainerLowest,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: LeaderboardCard(
                            topUsers: [
                              // Capitalize display name for each entry
                              (
                                rank: entry.rank,
                                username: _capitalizeDisplayName(
                                  entry.username,
                                ),
                                score: entry.score,
                              ),
                            ],
                          )._buildLeaderboardTile(
                            context,
                            rank: entry.rank,
                            username: _capitalizeDisplayName(entry.username),
                            score: entry.score,
                            isCurrentUser: false,
                          ),
                        ),
                      );
                    },
                    separatorBuilder:
                        (context, index) =>
                            const SizedBox(height: 4), // Decreased spacing
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
          ),
        ],
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

// Helper to capitalize display names (e.g., 'john, d.' -> 'John, D.')
String _capitalizeDisplayName(String name) {
  final parts = name.split(',');
  if (parts.length == 2) {
    final first = parts[0].trim();
    final last = parts[1].trim();
    return '${_capitalize(first)}, ${_capitalize(last)}';
  }
  return _capitalize(name);
}

String _capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}
