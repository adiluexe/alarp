import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/profile/widgets/stats_card.dart';
import 'package:alarp/features/profile/widgets/leaderboard_card.dart';
import 'package:alarp/features/profile/widgets/achievements_grid.dart';
import 'package:alarp/features/profile/widgets/activity_heatmap_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:alarp/features/auth/controllers/auth_controller.dart'; // Import AuthController for sign out
import 'package:alarp/core/providers/supabase_providers.dart'; // Import userProvider

import 'package:alarp/features/profile/controllers/leaderboard_providers.dart';
import 'package:alarp/core/navigation/app_router.dart';
import 'package:alarp/features/profile/controllers/challenge_history_provider.dart';
import 'package:intl/intl.dart';
import 'package:alarp/data/repositories/practice_repository.dart'; // Import practice providers
import 'package:alarp/features/learn/controllers/learn_progress_provider.dart';
import 'package:alarp/core/providers/guest_mode_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  String _formatDuration(int totalSeconds) {
    if (totalSeconds < 0) return "0m";
    final duration = Duration(seconds: totalSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return "${hours}h ${minutes}m";
    } else if (minutes > 0) {
      return "${minutes}m";
    } else {
      return "<1m";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final currentUser = ref.watch(currentUserProvider);
    // Watch the overall accuracy provider
    final overallAccuracyAsync = ref.watch(overallAccuracyProvider);

    const String dailyChallengeId = 'upper_extremities_10rounds';

    final leaderboardAsync = ref.watch(
      dailyLeaderboardProvider(dailyChallengeId),
    );
    final userRankAsync = ref.watch(userDailyRankProvider(dailyChallengeId));
    final challengeHistoryAsync = ref.watch(challengeHistoryProvider);

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: userProfileAsync.when(
          data: (profileData) {
            final firstName = profileData?['first_name'] as String?;
            final lastName = profileData?['last_name'] as String?;
            final username = profileData?['username'] as String? ?? 'User';
            final email = currentUser?.email ?? 'No email';
            final currentStreak = profileData?['current_streak'] as int? ?? 0;
            final totalAppTimeSeconds =
                profileData?['total_app_time_seconds'] as int? ?? 0;
            final totalAppTimeFormatted = _formatDuration(totalAppTimeSeconds);

            final completedLessons = ref.watch(learnProgressProvider).length;
            final totalLessons = 36;
            // Use the fetched overall accuracy, default to 0.0 if loading/error
            final averageAccuracy = overallAccuracyAsync.value ?? 0.0;
            final leaderboardRank = userRankAsync.asData?.value?.rank ?? 0;

            String displayName = username;
            if (firstName != null && firstName.isNotEmpty) {
              displayName = firstName;
              if (lastName != null && lastName.isNotEmpty) {
                displayName += ' $lastName';
              }
            }
            String initial =
                displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: AppTheme.primaryColor,
                  expandedHeight: 0,
                  floating: true,
                  pinned: false,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        SolarIconsOutline.settings,
                        color: Colors.white,
                      ),
                      onPressed: () => context.push(AppRoutes.settings),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: _buildProfileHeader(
                    context,
                    displayName,
                    email,
                    initial,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: _buildStatsOverview(
                      context,
                      streak: currentStreak,
                      timeSpent: totalAppTimeFormatted,
                      lessonsCompleted: '$completedLessons/$totalLessons',
                      accuracy: averageAccuracy,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: ActivityHeatmapWidget(
                      endDate: DateTime.now(),
                      activityData: {
                        // TODO: Connect to real activity data
                        for (int i = 0; i < 90; i++)
                          if (i % 3 != 0) // Simulate some activity
                            DateUtils.dateOnly(
                                  DateTime.now().subtract(Duration(days: i)),
                                ):
                                (i % 5) + 1,
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Daily Leaderboard',
                              style: textTheme.titleLarge,
                            ),
                            TextButton(
                              onPressed: () {
                                context.push(AppRoutes.leaderboard);
                              },
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        leaderboardAsync.when(
                          data: (leaderboardData) {
                            return LeaderboardCard(
                              currentUserRank:
                                  leaderboardRank > 0 ? leaderboardRank : null,
                              topUsers: leaderboardData,
                            );
                          },
                          loading:
                              () => const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 32.0),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          error:
                              (error, stack) => Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                  ),
                                  child: Text(
                                    'Error loading leaderboard: $error',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildAchievements(
                      context,
                      ref,
                      currentStreak,
                      completedLessons,
                      averageAccuracy,
                      totalAppTimeSeconds,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Challenges',
                              style: textTheme.titleMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                context.push(AppRoutes.challengeHistory);
                              },
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        challengeHistoryAsync.when(
                          data: (history) {
                            if (history.isEmpty) {
                              return Text(
                                'No recent challenge attempts.',
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textColor.withAlpha(
                                    (0.6 * 255).round(),
                                  ),
                                ),
                              );
                            }
                            final recent = history.take(3).toList();
                            return Column(
                              children: [
                                for (final attempt in recent)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildHistoryCard(context, attempt),
                                  ),
                              ],
                            );
                          },
                          loading:
                              () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                          error:
                              (error, stack) => Text(
                                'Could not load challenge history.',
                                style: textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                // --- Navigation Links Section ---

                // --- End Navigation Links Section ---
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 24.0,
                    ),
                    child: _buildSignOutButton(context, ref),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error loading profile: $error'),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    String name,
    String email,
    String initial,
  ) {
    const Color contentColor = Colors.white;
    final Color secondaryContentColor = contentColor.withAlpha(
      (0.8 * 255).round(),
    );
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor.withAlpha((0.8 * 255).round()),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withAlpha((0.2 * 255).round()),
            child: Text(
              initial,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: contentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: 'Chillax',
              color: contentColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: secondaryContentColor),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              context.push(AppRoutes.editProfile);
            },
            icon: const Icon(SolarIconsOutline.penNewSquare, size: 18),
            label: const Text('Edit Profile'),
            style: OutlinedButton.styleFrom(
              foregroundColor: contentColor,
              side: BorderSide(
                color: contentColor.withAlpha((0.5 * 255).round()),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              textStyle: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const SizedBox(height: 24),
          // Quick Links Section inside the header for better visibility
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeaderAction(
                context,
                icon: SolarIconsBold.bookmark,
                label: 'Saved',
                onTap: () => context.push(AppRoutes.bookmarks),
                color: contentColor,
              ),
              _buildHeaderAction(
                context,
                icon: SolarIconsBold.settings,
                label: 'Settings',
                onTap: () => context.push(AppRoutes.settings),
                color: contentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview(
    BuildContext context, {
    required int streak,
    required String timeSpent,
    required String lessonsCompleted,
    required double accuracy,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatsCard(
                label: 'Streak',
                value: '$streak',
                unit: 'days',
                icon: SolarIconsBold.flame,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                label: 'Time Spent',
                value: timeSpent,
                unit: 'total',
                icon: SolarIconsBold.clockCircle,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                label: 'Lessons',
                value: lessonsCompleted,
                unit: 'completed',
                icon: SolarIconsBold.bookBookmark,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                label: 'Accuracy',
                value: '${accuracy.toStringAsFixed(1)}%',
                unit: 'overall',
                icon: SolarIconsBold.target,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievements(
    BuildContext context,
    WidgetRef ref,
    int streak,
    int lessonsCompleted,
    double accuracy,
    int totalTimeSeconds,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        AchievementsGrid(
          streak: streak,
          lessonsCompleted: lessonsCompleted,
          accuracy: accuracy,
          totalTimeSeconds: totalTimeSeconds,
        ),
      ],
    );
  }

  Widget _buildSignOutButton(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(guestModeProvider);
    return ElevatedButton.icon(
      onPressed: () async {
        if (isGuest) {
          // Guest mode: just exit demo, no Supabase sign-out needed
          ref.read(guestModeProvider.notifier).state = false;
          if (context.mounted) context.go(AppRoutes.getStarted);
          return;
        }

        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Sign Out'),
              ),
            ],
          ),
        );

        if (confirm == true) {
          await ref.read(authControllerProvider.notifier).signOut();
          if (context.mounted) context.go(AppRoutes.getStarted);
        }
      },
      icon: const Icon(SolarIconsOutline.logout),
      label: Text(isGuest ? 'Exit Demo Mode' : 'Sign Out'),
      style: ElevatedButton.styleFrom(
        backgroundColor: isGuest ? Colors.orange[700] : Colors.red[700],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, dynamic attempt) {
    final textTheme = Theme.of(context).textTheme;
    final formattedDate = DateFormat.yMMMd().add_jm().format(
      attempt.completedAt.toLocal(),
    );
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primaryColor.withAlpha(
                (0.12 * 255).round(),
              ),
              radius: 26,
              child: Icon(
                SolarIconsOutline.cupStar,
                color: AppTheme.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attempt.challengeTitle.isNotEmpty
                        ? attempt.challengeTitle
                        : 'Challenge',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Chillax',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppTheme.textColor.withAlpha((0.7 * 255).round()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${attempt.score} pts',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
