import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Import go_router
import 'package:solar_icons/solar_icons.dart'; // Import solar_icons
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/challenge/models/challenge.dart';
import 'package:alarp/features/challenge/widgets/challenge_card.dart';
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes

import 'package:intl/intl.dart'; // Import intl's DateFormat

// Import leaderboard related providers and widgets
import 'package:alarp/features/profile/controllers/leaderboard_providers.dart';
import 'package:alarp/features/profile/widgets/leaderboard_card.dart';
import 'package:alarp/features/profile/controllers/challenge_history_provider.dart';

class ChallengeScreen extends ConsumerWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Directly use the specific challenge instance for 'Today's Challenge'
    final Challenge todayChallenge = Challenge.upperExtremitiesChallenge;
    final textTheme = Theme.of(context).textTheme;

    // --- Leaderboard Data ---
    // Use the ID from the todayChallenge instance
    final String leaderboardChallengeId = todayChallenge.id;
    final leaderboardAsync = ref.watch(
      dailyLeaderboardProvider(leaderboardChallengeId),
    );
    final userRankAsync = ref.watch(
      userDailyRankProvider(leaderboardChallengeId),
    );
    final userRank = userRankAsync.asData?.value?.rank;
    // --- End Leaderboard Data ---

    // --- Challenge History Data ---
    final challengeHistoryAsync = ref.watch(challengeHistoryProvider);
    // --- End Challenge History Data ---

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // --- Header Section ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Challenge Mode',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontFamily: 'Chillax',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Test your skills with timed positioning exercises',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textColor.withAlpha(
                          (0.7 * 255).round(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // --- Hero Daily Challenge ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          SolarIconsBold.calendar,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Today\'s Challenge',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontFamily: 'Chillax',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ChallengeCard(
                      title: todayChallenge.title,
                      description: todayChallenge.description,
                      difficulty: todayChallenge.difficulty,
                      timeLimit:
                          '${todayChallenge.timeLimit.inMinutes}:${(todayChallenge.timeLimit.inSeconds % 60).toString().padLeft(2, '0')}',
                      participants: 48,
                      isActive: true,
                      gradientBackground: LinearGradient(
                        colors: [AppTheme.primaryColor, AppTheme.accentColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () {
                        context.push(
                          AppRoutes.challengeStartRoute(todayChallenge.id),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // --- Quick Play Modes ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Play',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: 'Chillax',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickPlayCard(
                            context,
                            title: 'Speed Run',
                            subtitle: '30 Qs in 3 Mins',
                            icon: SolarIconsBold.stopwatch,
                            color: Colors.orange,
                            onTap: () {
                              // TODO: Navigate to Speed Run
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickPlayCard(
                            context,
                            title: 'Survival',
                            subtitle: 'One Life Only',
                            icon: SolarIconsBold.shieldWarning,
                            color: Colors.redAccent,
                            onTap: () {
                              // TODO: Navigate to Survival
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickPlayCard(
                            context,
                            title: 'Region Master',
                            subtitle: 'Focus on areas',
                            icon: SolarIconsBold.mapPoint,
                            color: Colors.purpleAccent,
                            onTap: () {
                              // TODO: Navigate to Region Master
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickPlayCard(
                            context,
                            title: 'Flashcards',
                            subtitle: 'Rapid Review',
                            icon: SolarIconsBold.gallery,
                            color: Colors.blueAccent,
                            onTap: () {
                              context.push(AppRoutes.flashcards);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // --- Leaderboard Preview Section ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Daily Leaderboard', style: textTheme.titleLarge),
                        TextButton(
                          onPressed: () {
                            context.push(AppRoutes.leaderboard);
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    leaderboardAsync.when(
                      data: (leaderboardData) {
                        return LeaderboardCard(
                          currentUserRank: userRank,
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
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            // --- Recent Challenge History Section ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recent Challenges', style: textTheme.titleMedium),
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
                          () =>
                              const Center(child: CircularProgressIndicator()),
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
          ],
        ),
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

  Widget _buildQuickPlayCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isHorizontal = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child:
            isHorizontal
                ? Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            subtitle,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      SolarIconsOutline.altArrowRight,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
