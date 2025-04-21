import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/profile/widgets/stats_card.dart';
import 'package:alarp/features/profile/widgets/leaderboard_card.dart';
import 'package:alarp/features/profile/widgets/achievements_grid.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes
import 'package:alarp/features/auth/controllers/auth_controller.dart'; // Import AuthController

// Convert to ConsumerWidget to access ref
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Add WidgetRef ref
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

            // Sign Out Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24.0,
                ),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Show confirmation dialog before signing out
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Confirm Sign Out'),
                            content: const Text(
                              'Are you sure you want to sign out?',
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                child: const Text('Sign Out'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                    );

                    // If confirmed, call the sign out method
                    if (confirm == true) {
                      await ref.read(authControllerProvider.notifier).signOut();
                      // GoRouter redirect will handle navigation based on auth state change
                    }
                  },
                  icon: const Icon(SolarIconsOutline.logout),
                  label: const Text('Sign Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red[700], // Use a distinct color for sign out
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    // Define content color for contrast against gradient
    const Color contentColor = Colors.white;
    final Color secondaryContentColor = contentColor.withOpacity(0.8);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Replace solid color with gradient
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor.withOpacity(0.8), // Example gradient
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            // Adjust shadow color if needed
            color: AppTheme.primaryColor.withOpacity(0.3),
            offset: const Offset(0, 4), // Slightly larger offset for gradient
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile picture - Adjust background/text color for contrast
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withOpacity(
              0.2,
            ), // Lighter background
            child: Text(
              "S", // First letter of username
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: contentColor, // Use white text
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name - Use white text
          Text(
            "Student",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: 'Chillax',
              color: contentColor, // Use white text
            ),
          ),
          const SizedBox(height: 4),

          // Email or student ID - Use semi-transparent white text
          Text(
            "student@university.edu",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: secondaryContentColor, // Use semi-transparent white
            ),
          ),

          const SizedBox(height: 16),

          // Edit profile button - Style for contrast on gradient
          OutlinedButton.icon(
            onPressed: () {
              // Navigate to edit profile
            },
            icon: Icon(
              SolarIconsOutline.pen,
              size: 18,
              color: contentColor,
            ), // White icon
            label: Text(
              'Edit Profile',
              style: TextStyle(color: contentColor), // White text
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: contentColor.withOpacity(0.5),
              ), // White border
              foregroundColor: contentColor, // Ensure ripple uses white
              shape: RoundedRectangleBorder(
                // Ensure consistent radius
                borderRadius: BorderRadius.circular(8),
              ),
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
                // Navigate to full leaderboard view using push
                context.push(AppRoutes.leaderboard);
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
