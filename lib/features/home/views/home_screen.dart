import 'package:alarp/core/widgets/action_card.dart';
import 'package:alarp/core/widgets/learning_progress_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes
import 'package:alarp/features/challenge/models/challenge.dart'; // Import Challenge for daily challenge ID

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock data - in a real app, this would come from a controller
  final String userName = "Student";
  final int streakDays = 5;
  final int completedLessons = 12;
  final int totalLessons = 36;
  final double weeklyAccuracy = 82.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildStats(), // Moved up
              const SizedBox(height: 24),
              _buildQuickActions(), // Moved down
              const SizedBox(height: 24),
              _buildSkeletonExplorer(),
              const SizedBox(height: 24),
              _buildLearningProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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

  Widget _buildQuickActions() {
    // Get today's challenge ID for navigation
    // Use the 5-step challenge ID
    final String dailyChallengeId = Challenge.forearmApChallenge.id;
    // Define a width for the cards
    const double cardWidth = 280.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions', // Changed title slightly
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        // Wrap the cards in a horizontally scrolling view
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          // Add padding so cards don't touch edges
          padding: const EdgeInsets.symmetric(
            horizontal: 4.0,
          ), // Adjust as needed
          clipBehavior: Clip.none, // Allow shadows to render outside bounds
          // Use IntrinsicHeight to make cards in the row the same height
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Wrap each card in a SizedBox to control its width
                SizedBox(
                  width: cardWidth,
                  child: ActionCard(
                    title: 'Continue Learning',
                    subtitle:
                        'AP Chest Projection', // Placeholder - needs dynamic update
                    description: 'Continue where you left off',
                    icon: SolarIconsBold.bookBookmark,
                    color: AppTheme.primaryColor,
                    // progress: 0.65, // Placeholder
                    onTap: () {
                      context.go(AppRoutes.learn);
                    },
                  ),
                ),
                const SizedBox(width: 12), // Spacing between cards
                SizedBox(
                  width: cardWidth,
                  child: ActionCard(
                    title: 'Daily Challenge',
                    // Use the 5-step challenge title
                    subtitle: Challenge.forearmApChallenge.title,
                    description: 'Complete today\'s challenge',
                    icon: SolarIconsBold.medalStar,
                    color: AppTheme.secondaryColor,
                    onTap: () {
                      // Use the helper method to generate the correct route
                      // Use push for consistency
                      context.push(
                        AppRoutes.challengeStartRoute(dailyChallengeId),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12), // Spacing between cards
                SizedBox(
                  width: cardWidth,
                  child: ActionCard(
                    title: 'Practice Session',
                    subtitle: 'Hands-on positioning',
                    description: 'Practice your skills', // Updated description
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

  Widget _buildStats() {
    // Define gradient
    final statsGradient = LinearGradient(
      colors: [
        // Updated gradient colors
        AppTheme.primaryColor.withOpacity(0.8),
        AppTheme.secondaryColor.withOpacity(0.7),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
    // Define text/icon color for contrast
    const Color contentColor = Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: statsGradient, // Apply gradient
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // Updated shadow color based on new gradient
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
              color: contentColor, // Use contrast color
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(
                'Completed',
                '$completedLessons/$totalLessons',
                'lessons',
                SolarIconsBold.diploma,
                contentColor, // Pass contrast color
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                'Accuracy',
                '${weeklyAccuracy.toStringAsFixed(1)}%',
                'this week',
                SolarIconsBold.target,
                contentColor, // Pass contrast color
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    String sublabel,
    IconData icon,
    Color contentColor, // Receive contrast color
  ) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // Use a semi-transparent white for the icon background
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            // Use the contrast color for the icon itself
            child: Icon(icon, color: contentColor, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                // Use contrast color with slight opacity
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: contentColor.withOpacity(0.8),
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: contentColor, // Use contrast color
                ),
              ),
              Text(
                sublabel,
                // Use contrast color with slight opacity
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

  Widget _buildSkeletonExplorer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Anatomy Explorer', // Improved section title
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ActionCard(
          title: '3D Skeleton Viewer', // Updated title
          subtitle: 'Interactive anatomical model', // Updated subtitle
          description:
              'Study bones and landmarks in detail', // Updated description
          icon: SolarIconsBold.bone, // Using bone icon
          // Use a more distinct color, e.g., Blue Grey
          color: AppTheme.primaryColor,
          onTap: () {
            context.go(AppRoutes.skeletonViewer);
          },
        ),
      ],
    );
  }

  Widget _buildLearningProgress() {
    // This would be a custom chart component
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
