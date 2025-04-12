import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:alarp/core/theme/app_theme.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/features/challenge/widgets/challenge_card.dart';
import 'package:alarp/features/challenge/widgets/leaderboard_preview.dart';
import 'package:alarp/features/challenge/widgets/feature_highlight_card.dart';
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes
import '../models/challenge.dart'; // Import Challenge model

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the placeholder challenge data
    final todayChallenge = Challenge.apForearmChallenge;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
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
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Feature highlights
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

            // Daily Challenge
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
                    // Use data from the model and add onTap navigation
                    ChallengeCard(
                      title: todayChallenge.title,
                      description: todayChallenge.description,
                      difficulty: todayChallenge.difficulty,
                      timeLimit:
                          '${todayChallenge.timeLimit.inMinutes}:${(todayChallenge.timeLimit.inSeconds % 60).toString().padLeft(2, '0')}',
                      participants: 48, // Placeholder
                      isActive: true,
                      onTap: () {
                        // Navigate to the start screen using the challenge ID
                        context.go(
                          '${AppRoutes.challenge}/${AppRoutes.challengeStart.replaceFirst(':challengeId', todayChallenge.id)}',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Leaderboard preview
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Leaderboard',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontFamily: 'Chillax',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            // Navigate to full leaderboard
                          },
                          icon: const Icon(SolarIconsOutline.ranking, size: 18),
                          label: const Text('View All'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const LeaderboardPreview(),
                  ],
                ),
              ),
            ),

            // Previous challenges
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Previous Challenges',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: 'Chillax',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const ChallengeCard(
                      title: 'PA Chest Positioning',
                      description:
                          'Position the patient correctly for a PA Chest X-ray',
                      difficulty: 'Beginner',
                      timeLimit: '2:30',
                      participants: 72,
                      isActive: false,
                      yourScore: '93%',
                    ),
                    const SizedBox(height: 12),
                    const ChallengeCard(
                      title: 'Lateral Skull',
                      description:
                          'Position the patient for a Lateral Skull projection',
                      difficulty: 'Advanced',
                      timeLimit: '4:00',
                      participants: 36,
                      isActive: false,
                      yourScore: '87%',
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
}
