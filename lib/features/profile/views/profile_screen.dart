import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/profile/widgets/stats_card.dart';
import 'package:alarp/features/profile/widgets/leaderboard_card.dart';
import 'package:alarp/features/profile/widgets/achievements_grid.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with profile info
            SliverToBoxAdapter(child: _buildProfileHeader(context)),

            // Stats Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: _buildStatsOverview(),
              ),
            ),

            // Leaderboard
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: _buildLeaderboard(context),
              ),
            ),

            // Achievements
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: _buildAchievements(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile picture
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Text(
              "S", // First letter of username
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            "Student",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: 'Chillax',
            ),
          ),
          const SizedBox(height: 4),

          // Email or student ID
          Text(
            "student@university.edu",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textColor.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 16),

          // Edit profile button
          OutlinedButton.icon(
            onPressed: () {
              // Navigate to edit profile
            },
            icon: const Icon(SolarIconsOutline.pen, size: 18),
            label: const Text('Edit Profile'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.primaryColor),
              foregroundColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
    return const StatsCard();
  }

  Widget _buildLeaderboard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Leaderboard',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Chillax',
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // Navigate to full leaderboard view
              },
              icon: const Icon(SolarIconsOutline.ranking, size: 18),
              label: const Text('See All'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const LeaderboardCard(),
      ],
    );
  }

  Widget _buildAchievements(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontFamily: 'Chillax',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        const AchievementsGrid(),
      ],
    );
  }
}
