import 'package:alarp/core/widgets/action_card.dart';
import 'package:alarp/core/widgets/learning_progress_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/core/navigation/app_router.dart';
import 'package:alarp/features/challenge/models/challenge.dart';
import 'package:alarp/core/providers/supabase_providers.dart'; // Import the profile provider

// Convert to ConsumerWidget
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the user profile provider
    final userProfileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pass user profile data to header and stats
              userProfileAsync.when(
                data: (profileData) {
                  // Extract data or use defaults
                  final userName =
                      profileData?['username'] as String? ?? 'User';
                  final streakDays =
                      profileData?['current_streak'] as int? ?? 0;
                  final completedLessons =
                      0; // TODO: Fetch actual completed lessons
                  final totalLessons = 36; // TODO: Fetch actual total lessons
                  final weeklyAccuracy = 0.0; // TODO: Fetch actual accuracy

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, userName, streakDays),
                      const SizedBox(height: 24),
                      _buildStats(
                        context,
                        completedLessons,
                        totalLessons,
                        weeklyAccuracy,
                      ),
                    ],
                  );
                },
                loading:
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, 'Loading...', 0),
                        const SizedBox(height: 24),
                        _buildStats(context, 0, 0, 0.0),
                      ],
                    ),
                error:
                    (error, stack) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, 'Error', 0),
                        const SizedBox(height: 24),
                        Center(child: Text('Error loading profile: $error')),
                      ],
                    ),
              ),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildSkeletonExplorer(context),
              const SizedBox(height: 24),
              _buildLearningProgress(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userName, int streakDays) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textColor.withOpacity(0.7),
              ),
            ),
            Text(
              userName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontFamily: 'Chillax',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(SolarIconsBold.fire, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 6),
              Text(
                '$streakDays day streak',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final String dailyChallengeId = Challenge.upperExtremitiesChallenge.id;
    const double cardWidth = 280.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          clipBehavior: Clip.none,
          child: IntrinsicHeight(
            child: Row(
              children: [
                SizedBox(
                  width: cardWidth,
                  child: ActionCard(
                    title: 'Continue Learning',
                    subtitle: 'AP Chest Projection',
                    description: 'Continue where you left off',
                    icon: SolarIconsBold.bookBookmark,
                    color: AppTheme.primaryColor,
                    onTap: () {
                      context.go(AppRoutes.learn);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: cardWidth,
                  child: ActionCard(
                    title: 'Daily Challenge',
                    subtitle: 'Upper Extremities',
                    description: 'Complete today\'s challenge',
                    icon: SolarIconsBold.medalStar,
                    color: AppTheme.secondaryColor,
                    onTap: () {
                      context.push(
                        AppRoutes.challengeStartRoute(dailyChallengeId),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: cardWidth,
                  child: ActionCard(
                    title: 'Practice Session',
                    subtitle: 'Hands-on positioning',
                    description: 'Practice your skills',
                    icon: SolarIconsBold.compassSquare,
                    color: AppTheme.accentColor,
                    onTap: () {
                      context.go(AppRoutes.practice);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStats(
    BuildContext context,
    int completedLessons,
    int totalLessons,
    double weeklyAccuracy,
  ) {
    final statsGradient = LinearGradient(
      colors: [
        AppTheme.primaryColor.withOpacity(0.8),
        AppTheme.secondaryColor.withOpacity(0.7),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
    const Color contentColor = Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: statsGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: contentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(
                context,
                'Completed',
                '$completedLessons/$totalLessons',
                'lessons',
                SolarIconsBold.diploma,
                contentColor,
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                context,
                'Accuracy',
                '${weeklyAccuracy.toStringAsFixed(1)}%',
                'this week',
                SolarIconsBold.target,
                contentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    String sublabel,
    IconData icon,
    Color contentColor,
  ) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: contentColor, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: contentColor.withOpacity(0.8),
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: contentColor,
                ),
              ),
              Text(
                sublabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: contentColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonExplorer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Anatomy Explorer', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ActionCard(
          title: '3D Skeleton Viewer',
          subtitle: 'Interactive anatomical model',
          description: 'Study bones and landmarks in detail',
          icon: SolarIconsBold.bone,
          color: AppTheme.primaryColor,
          onTap: () {
            context.go(AppRoutes.skeletonViewer);
          },
        ),
      ],
    );
  }

  Widget _buildLearningProgress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Learning Trends', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Container(
          height: 200,
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
          child: const LearningProgressChart(),
        ),
      ],
    );
  }
}
