import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/profile/widgets/stats_card.dart';
import 'package:alarp/features/profile/widgets/leaderboard_card.dart';
import 'package:alarp/features/profile/widgets/achievements_grid.dart';
import 'package:go_router/go_router.dart';
import 'package:alarp/features/auth/controllers/auth_controller.dart';
import 'package:alarp/core/providers/supabase_providers.dart';
import 'package:alarp/core/services/shared_preferences_service.dart';
import 'package:alarp/features/profile/controllers/leaderboard_providers.dart';
import 'package:alarp/data/repositories/profile_repository.dart';
import 'package:alarp/core/navigation/app_router.dart';

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

    const String dailyChallengeId = 'upper_extremities_10rounds';

    final leaderboardAsync = ref.watch(
      dailyLeaderboardProvider(dailyChallengeId),
    );
    final userRankAsync = ref.watch(userDailyRankProvider(dailyChallengeId));

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

            final completedLessons = 0;
            final totalLessons = 36;
            final averageAccuracy = 0.0;
            final leaderboardRank = userRankAsync.asData?.value?.rank ?? 0;
            final achievementsData = [];

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
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                    child: _buildAchievements(context, achievementsData),
                  ),
                ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile (Not Implemented)')),
              );
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Statistics', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                label: 'Current Streak',
                value: '$streak',
                unit: 'days',
                icon: SolarIconsBold.fire,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                label: 'Time Spent',
                value: timeSpent,
                unit: 'total',
                icon: SolarIconsBold.clockCircle,
                color: AppTheme.secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                label: 'Lessons Done',
                value: lessonsCompleted,
                unit: 'completed',
                icon: SolarIconsBold.notebook,
                color: AppTheme.accentColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                label: 'Avg. Accuracy',
                value: '${accuracy.toStringAsFixed(1)}%',
                unit: 'overall',
                icon: SolarIconsBold.target,
                color: Colors.orange.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievements(
    BuildContext context,
    List<dynamic> achievementsData,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        AchievementsGrid(
          // TODO: Update AchievementsGrid widget to accept achievements
          // achievements: const [
          //   {
          //     'name': 'Streak Starter',
          //     'achieved': true,
          //     'icon': SolarIconsBold.fire,
          //   },
          //   {
          //     'name': 'Quick Learner',
          //     'achieved': true,
          //     'icon': SolarIconsBold.notebook,
          //   },
          //   {
          //     'name': 'Sharp Shooter',
          //     'achieved': false,
          //     'icon': SolarIconsBold.target,
          //   },
          //   {
          //     'name': 'Challenge Champ',
          //     'achieved': false,
          //     'icon': SolarIconsBold.medalStar,
          //   },
          //   {
          //     'name': 'Time Master',
          //     'achieved': true,
          //     'icon': SolarIconsBold.clockCircle,
          //   },
          //   {
          //     'name': 'Perfect Score',
          //     'achieved': false,
          //     'icon': SolarIconsBold.verifiedCheck,
          //   },
          // ],
        ),
      ],
    );
  }

  Widget _buildSignOutButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
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
          final prefsService = ref.read(sharedPreferencesServiceProvider);
          await prefsService?.clearAll();

          await ref.read(authControllerProvider.notifier).signOut();
        }
      },
      icon: const Icon(SolarIconsOutline.logout),
      label: const Text('Sign Out'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
