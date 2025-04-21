import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/profile/widgets/stats_card.dart';
import 'package:alarp/features/profile/widgets/leaderboard_card.dart';
import 'package:alarp/features/profile/widgets/achievements_grid.dart';
import 'package:go_router/go_router.dart';
import 'package:alarp/core/navigation/app_router.dart';
import 'package:alarp/features/auth/controllers/auth_controller.dart';
import 'package:alarp/core/providers/supabase_providers.dart'; // Import providers

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch user profile and current user (for email fallback)
    final userProfileAsync = ref.watch(userProfileProvider);
    final currentUser = ref.watch(
      currentUserProvider,
    ); // Get Supabase user for email

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with profile info - Use AsyncValue.when
            userProfileAsync.when(
              data: (profileData) {
                // Extract data or use defaults/fallbacks
                final firstName = profileData?['first_name'] as String?;
                final lastName = profileData?['last_name'] as String?;
                final username = profileData?['username'] as String? ?? 'User';
                final email =
                    currentUser?.email ?? 'No email'; // Fallback email

                // Determine display name: First Last, First, Username
                String displayName = username;
                if (firstName != null && firstName.isNotEmpty) {
                  displayName = firstName;
                  if (lastName != null && lastName.isNotEmpty) {
                    displayName += ' $lastName';
                  }
                }

                // Determine initial for avatar
                String initial =
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

                return SliverToBoxAdapter(
                  child: _buildProfileHeader(
                    context,
                    displayName,
                    email,
                    initial,
                  ),
                );
              },
              loading:
                  () => SliverToBoxAdapter(
                    child: _buildProfileHeader(
                      context,
                      'Loading...',
                      'Loading...',
                      '?',
                    ), // Loading state
                  ),
              error:
                  (error, stack) => SliverToBoxAdapter(
                    child: _buildProfileHeader(
                      context,
                      'Error',
                      'Error',
                      '!',
                    ), // Error state
                  ),
            ),

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

  // Update _buildProfileHeader to accept dynamic data
  Widget _buildProfileHeader(
    BuildContext context,
    String name,
    String email,
    String initial,
  ) {
    // Define content color for contrast against gradient
    const Color contentColor = Colors.white;
    final Color secondaryContentColor = contentColor.withOpacity(0.8);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
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
            color: AppTheme.primaryColor.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              initial, // Use dynamic initial
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: contentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name, // Use dynamic name
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: 'Chillax',
              color: contentColor,
            ),
            textAlign: TextAlign.center, // Center name if long
          ),
          const SizedBox(height: 4),
          Text(
            email, // Use dynamic email
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: secondaryContentColor),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Navigate to edit profile screen
            },
            icon: Icon(SolarIconsOutline.pen, size: 18, color: contentColor),
            label: Text('Edit Profile', style: TextStyle(color: contentColor)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: contentColor.withOpacity(0.5)),
              foregroundColor: contentColor,
              shape: RoundedRectangleBorder(
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
