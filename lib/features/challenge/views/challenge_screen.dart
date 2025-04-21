import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Import go_router
import 'package:solar_icons/solar_icons.dart'; // Import solar_icons
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/challenge/models/challenge.dart';
import 'package:alarp/features/challenge/widgets/challenge_card.dart';
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes
import 'package:alarp/features/challenge/widgets/feature_highlight_card.dart'; // Import FeatureHighlightCard

// Import leaderboard related providers and widgets
import 'package:alarp/features/profile/controllers/leaderboard_providers.dart';
import 'package:alarp/features/profile/widgets/leaderboard_card.dart';

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

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Challenges'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: CustomScrollView(
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'Chillax',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Test your skills with timed positioning exercises',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textColor.withAlpha((0.7 * 255).round()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // --- Feature Highlights ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FeatureHighlightCard(
                    icon: SolarIconsBold.stopwatch,
                    title: 'Beat the Clock',
                    description:
                        'Earn more points with faster submissions while maintaining accuracy',
                    color: AppTheme.secondaryColor,
                  ),
                  const SizedBox(height: 12),
                  const FeatureHighlightCard(
                    icon: SolarIconsBold.medalStar,
                    title: 'Compete for Top Rank',
                    description:
                        'See how you compare to others on the leaderboard',
                    color: AppTheme.accentColor,
                  ),
                  const SizedBox(height: 12),
                  const FeatureHighlightCard(
                    icon: SolarIconsBold.medalRibbonStar,
                    title: 'Unlock Achievements',
                    description:
                        'Earn badges and certifications as you master positioning',
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
          // --- Daily Challenge ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Challenge',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'Chillax',
                      fontWeight: FontWeight.w600,
                    ),
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
                      colors: [
                        AppTheme.primaryColor.withAlpha((0.8 * 255).round()),
                        AppTheme.accentColor.withAlpha((0.6 * 255).round()),
                      ],
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
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
        ],
      ),
    );
  }
}
