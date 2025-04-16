import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:alarp/features/learn/views/learn_screen.dart';
import 'package:alarp/features/learn/views/learn_region_detail_screen.dart';
import 'package:alarp/features/learn/views/learn_lesson_screen.dart'; // Ensure this points to the updated screen
import 'package:alarp/features/practice/views/practice_screen.dart';
import 'package:alarp/features/practice/views/region_detail_screen.dart';
// Import the renamed screen
import 'package:alarp/features/practice/views/collimation_practice_screen.dart';
import 'package:alarp/features/home/views/home_screen.dart';
import 'package:alarp/features/challenge/views/challenge_screen.dart';
import 'package:alarp/features/challenge/views/challenge_start_screen.dart'; // Import start screen
import 'package:alarp/features/challenge/views/challenge_active_screen.dart'; // Import active screen
import 'package:alarp/features/profile/views/profile_screen.dart';
import 'package:alarp/core/navigation/navigation.dart'; // Import the main navigation shell
import 'package:alarp/features/practice/models/body_region.dart'; // Import BodyRegions
import 'package:alarp/features/challenge/models/challenge.dart'; // Import Challenge model
import 'package:alarp/features/anatomy/views/skeleton_viewer_screen.dart'; // Import the new screen
import 'package:alarp/features/practice/views/recent_practice_list_screen.dart'; // Ensure this import is present
import 'package:alarp/features/profile/views/leaderboard_screen.dart'; // Import the new leaderboard screen

// Define route paths
class AppRoutes {
  static const home = '/';
  static const learn = '/learn';
  static const learnRegionDetail = 'region/:regionId'; // Relative to /learn
  static const learnLesson =
      'part/:bodyPartId'; // Corrected relative path to parent
  static const practice = '/practice';
  static const practiceRegionDetail =
      'region/:regionId'; // Relative to /practice
  // Keep the same route structure, just update the screen it points to
  static const practicePositioning =
      'part/:bodyPartId/projection/:projectionName'; // Relative to practiceRegionDetail
  static const challenge = '/challenge';
  // New challenge routes (relative to /challenge)
  static const challengeStart = 'start/:challengeId';
  static const challengeActivePath = 'active/:challengeId'; // Path segment
  static const profile = '/profile';
  static const skeletonViewer = '/skeleton'; // New route for skeleton viewer
  static const recentPracticeList =
      '/recent-practice'; // Verify the constant path
  static const leaderboard =
      '/leaderboard'; // New route for the full leaderboard

  // Helper method to build the full path for navigation
  static String challengeActive(String challengeId) =>
      '/challenge/active/$challengeId';
}

// Private navigator keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    navigatorKey: _rootNavigatorKey,
    routes: [
      // Routes accessible without bottom nav bar
      GoRoute(
        path: AppRoutes.skeletonViewer,
        builder: (context, state) => const SkeletonViewerScreen(),
      ),
      GoRoute(
        path: AppRoutes.recentPracticeList, // Verify path uses the constant
        builder:
            (context, state) =>
                const RecentPracticeListScreen(), // Verify builder points to the correct screen
      ),
      // Add the new leaderboard route here (outside the ShellRoute)
      GoRoute(
        path: AppRoutes.leaderboard,
        builder: (context, state) => const LeaderboardScreen(),
      ),
      // MOVED: Collimation Practice Screen (outside ShellRoute)
      GoRoute(
        // Define the full path
        path:
            '${AppRoutes.practice}/${AppRoutes.practiceRegionDetail}/${AppRoutes.practicePositioning}',
        builder: (context, state) {
          final regionId = state.pathParameters['regionId']!;
          final bodyPartId = state.pathParameters['bodyPartId']!;
          final projectionName = state.pathParameters['projectionName']!;
          return CollimationPracticeScreen(
            regionId: regionId,
            bodyPartId: bodyPartId,
            initialProjectionName: projectionName,
          );
        },
      ),
      // Main application shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          // Determine the index based on the current route
          int index = 0;
          if (state.matchedLocation.startsWith(AppRoutes.learn)) {
            index = 1;
          } else if (state.matchedLocation.startsWith(AppRoutes.practice)) {
            index = 2;
          } else if (state.matchedLocation.startsWith(AppRoutes.challenge)) {
            index = 3;
          } else if (state.matchedLocation.startsWith(AppRoutes.profile)) {
            index = 4;
          }
          // Pass the child widget (the matched screen) to the Navigation shell
          return Navigation(currentIndex: index, child: child);
        },
        routes: [
          // Routes within the shell
          GoRoute(
            path: AppRoutes.home,
            pageBuilder:
                (context, state) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.learn,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: LearnScreen()),
            routes: [
              GoRoute(
                path:
                    AppRoutes
                        .learnRegionDetail, // e.g., /learn/region/upper_extremity
                builder: (context, state) {
                  final regionId = state.pathParameters['regionId']!;
                  return LearnRegionDetailScreen(regionId: regionId);
                },
                routes: [
                  GoRoute(
                    path:
                        AppRoutes
                            .learnLesson, // Corrected relative path: part/:bodyPartId
                    builder: (context, state) {
                      final lessonId =
                          state
                              .pathParameters['bodyPartId']!; // Use bodyPartId as lessonId
                      return LearnLessonScreen(
                        lessonId: lessonId, // Pass the ID here
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.practice,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: PracticeScreen()),
            routes: [
              GoRoute(
                path:
                    AppRoutes
                        .practiceRegionDetail, // e.g., /practice/region/upper_extremity
                builder: (context, state) {
                  final regionId = state.pathParameters['regionId']!;
                  // Assuming BodyRegions.getRegionById exists and is accessible
                  final region = BodyRegions.getRegionById(regionId);
                  return RegionDetailScreen(region: region);
                },
                routes: [
                  // REMOVED CollimationPracticeScreen route from here
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.challenge,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: ChallengeScreen()),
            routes: [
              // Route for Challenge Start Screen
              GoRoute(
                path:
                    AppRoutes
                        .challengeStart, // e.g., /challenge/start/ch_ap_forearm_01
                builder: (context, state) {
                  final challengeId = state.pathParameters['challengeId']!;
                  // Fetch challenge data (using static method for now)
                  final challenge = Challenge.getChallengeById(challengeId);
                  // Override the provider for this specific route
                  return ProviderScope(
                    overrides: [
                      currentChallengeProvider.overrideWithValue(challenge),
                    ],
                    child: ChallengeStartScreen(challengeId: challengeId),
                  );
                },
              ),
              // Route for Active Challenge Screen
              GoRoute(
                path:
                    AppRoutes
                        .challengeActivePath, // e.g., /challenge/active/ch_ap_forearm_01
                builder: (context, state) {
                  final challengeId = state.pathParameters['challengeId']!;
                  final challenge = Challenge.getChallengeById(challengeId);
                  // Override the provider for this specific route
                  return ProviderScope(
                    overrides: [
                      activeChallengeProvider.overrideWithValue(challenge),
                    ],
                    child: ChallengeActiveScreen(challengeId: challengeId),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
      // Add other top-level routes if needed (e.g., login screen outside the shell)
    ],
    // Optional: Add error handling
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(child: Text('Page not found: ${state.error}')),
        ),
  );
});

// You'll also need to update main.dart to use this router provider
// and potentially modify the Navigation widget to accept the child parameter
