import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/data/repositories/profile_repository.dart';
import 'package:alarp/features/profile/widgets/leaderboard_card.dart';
import 'package:go_router/go_router.dart';

final fullLeaderboardProvider =
    FutureProvider.family<List<LeaderboardEntry>, String>((
  ref,
  challengeId,
) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getDailyLeaderboard(challengeId, limit: 25);
}, name: 'fullLeaderboardProvider');

final allTimeLeaderboardProvider =
    FutureProvider.family<List<LeaderboardEntry>, String>((
  ref,
  challengeId,
) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getAllTimeLeaderboard(challengeId);
}, name: 'allTimeLeaderboardProvider');

final leaderboardTypeProvider = StateProvider<LeaderboardType>(
  (ref) => LeaderboardType.today,
);

enum LeaderboardType { today, allTime }

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  final String challengeId = 'upper_extremities_10rounds';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardType = ref.watch(leaderboardTypeProvider);
    final leaderboardAsync = leaderboardType == LeaderboardType.today
        ? ref.watch(fullLeaderboardProvider(challengeId))
        : ref.watch(allTimeLeaderboardProvider(challengeId));

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
        elevation: 0,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Tab toggle
          Container(
            color: AppTheme.primaryColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                  icon: Icon(SolarIconsBold.medalRibbonStar),
                ),
              ],
              selected: {leaderboardType},
              onSelectionChanged: (newSelection) {
                ref.read(leaderboardTypeProvider.notifier).state =
                    newSelection.first;
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return Colors.white.withValues(alpha: 0.15);
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppTheme.primaryColor;
                  }
                  return Colors.white;
                }),
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
                    return _buildEmptyState(context, leaderboardType);
                  }

                  final top3 = leaderboardData.take(3).toList();
                  final rest = leaderboardData.skip(3).toList();

                  return ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      // Podium section
                      if (top3.isNotEmpty)
                        _buildPodium(context, top3),

                      // Rest of the list
                      if (rest.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                          child: Text(
                            'Rankings',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textColor
                                      .withValues(alpha: 0.6),
                                ),
                          ),
                        ),
                        ...rest.asMap().entries.map((entry) {
                          final index = entry.key;
                          final e = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: _buildRankTile(context, e),
                          )
                              .animate()
                              .fadeIn(
                                delay:
                                    Duration(milliseconds: 300 + index * 60),
                                duration: 300.ms,
                              )
                              .slideX(begin: 0.08, end: 0);
                        }),
                      ],
                    ],
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          SolarIconsOutline.dangerTriangle,
                          size: 48,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Could not load leaderboard',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
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

  Widget _buildEmptyState(
      BuildContext context, LeaderboardType leaderboardType) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            SolarIconsBold.cup,
            size: 64,
            color: Colors.grey.shade300,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(
                begin: 1.0,
                end: 1.08,
                duration: 1800.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(height: 20),
          Text(
            leaderboardType == LeaderboardType.today
                ? 'No scores today yet!'
                : 'No scores yet!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to claim the top spot.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade400,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(BuildContext context, List<LeaderboardEntry> top3) {
    // Podium order: 2nd (left), 1st (center), 3rd (right)
    final podiumOrder = <LeaderboardEntry?>[];
    podiumOrder.add(top3.length > 1 ? top3[1] : null); // 2nd
    podiumOrder.add(top3[0]); // 1st
    podiumOrder.add(top3.length > 2 ? top3[2] : null); // 3rd

    final podiumHeights = [80.0, 110.0, 60.0];
    final podiumColors = [
      Colors.grey.shade400,
      Colors.amber.shade600,
      Colors.brown.shade400,
    ];
    final delays = [200, 0, 400]; // 1st animates first

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.08),
            AppTheme.accentColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(3, (i) {
          final entry = podiumOrder[i];
          if (entry == null) return const Expanded(child: SizedBox.shrink());

          return Expanded(
            child: Column(
              children: [
                // Avatar + name
                Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: i == 1 ? 30 : 24,
                          backgroundColor:
                              podiumColors[i].withValues(alpha: 0.2),
                          child: Text(
                            entry.username.isNotEmpty
                                ? entry.username[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: podiumColors[i],
                              fontWeight: FontWeight.bold,
                              fontSize: i == 1 ? 22 : 16,
                              fontFamily: 'Chillax',
                            ),
                          ),
                        ),
                        if (i == 1)
                          Positioned(
                            top: -12,
                            left: 0,
                            right: 0,
                            child: const Text(
                              '👑',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _capitalizeDisplayName(entry.username)
                          .split(',')
                          .first
                          .trim(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textColor,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${entry.score} pts',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: podiumColors[i],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Podium block
                Container(
                  height: podiumHeights[i],
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        podiumColors[i].withValues(alpha: 0.7),
                        podiumColors[i],
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '#${entry.rank}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Chillax',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            )
                .animate()
                .slideY(
                  begin: 0.3,
                  end: 0,
                  delay: Duration(milliseconds: delays[i]),
                  duration: 500.ms,
                  curve: Curves.easeOut,
                )
                .fadeIn(
                  delay: Duration(milliseconds: delays[i]),
                  duration: 400.ms,
                ),
          );
        }),
      ),
    );
  }

  Widget _buildRankTile(BuildContext context, LeaderboardEntry entry) {
    final theme = Theme.of(context);
    final rankColor = entry.rank == 1
        ? Colors.amber.shade700
        : entry.rank == 2
            ? Colors.grey.shade500
            : entry.rank == 3
                ? Colors.brown.shade400
                : AppTheme.textColor.withValues(alpha: 0.6);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: SizedBox(
          width: 36,
          child: Text(
            '#${entry.rank}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: rankColor,
              fontFamily: 'Chillax',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        title: Text(
          _capitalizeDisplayName(entry.username),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          '${entry.score} pts',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}

String _capitalizeDisplayName(String name) {
  final parts = name.split(',');
  if (parts.length == 2) {
    return '${_capitalize(parts[0].trim())}, ${_capitalize(parts[1].trim())}';
  }
  return _capitalize(name);
}

String _capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

// Keep extension for backward compat with any other files importing it
extension LeaderboardTileBuilder on LeaderboardCard {
  Widget buildTile(
    BuildContext context, {
    required int rank,
    required String username,
    required int score,
    required bool isCurrentUser,
  }) =>
      const SizedBox.shrink();
}
