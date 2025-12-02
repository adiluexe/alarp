import 'dart:async'; // Import for StreamSubscription
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:alarp/features/learn/views/learn_screen.dart';
import 'package:alarp/features/learn/views/learn_region_detail_screen.dart';
import 'package:alarp/features/learn/views/learn_lesson_screen.dart'; // Ensure this points to the updated screen
import 'package:alarp/features/learn/views/flashcard_screen.dart';
import 'package:alarp/features/challenge/views/speed_run_screen.dart';
import 'package:alarp/features/challenge/views/survival_screen.dart';

import 'package:alarp/features/profile/views/bookmarks_screen.dart';
import 'package:alarp/features/profile/views/edit_profile_screen.dart'; // Import EditProfileScreen
import 'package:alarp/features/challenge/views/region_master_screen.dart';
import 'package:alarp/features/practice/views/practice_screen.dart';
import 'package:alarp/features/practice/views/region_detail_screen.dart';
import 'package:alarp/features/practice/views/collimation_practice_screen.dart';
import 'package:alarp/features/home/views/home_screen.dart';
import 'package:alarp/features/challenge/views/challenge_screen.dart';
import 'package:alarp/features/challenge/views/challenge_start_screen.dart';
import 'package:alarp/features/challenge/views/challenge_active_screen.dart';
import 'package:alarp/features/profile/views/profile_screen.dart';
import 'package:alarp/core/navigation/navigation.dart';
import 'package:alarp/features/practice/models/body_region.dart';
import 'package:alarp/features/challenge/models/challenge.dart';
import 'package:alarp/features/anatomy/views/skeleton_viewer_screen.dart'; // Import the new screen
import 'package:alarp/features/practice/views/recent_practice_list_screen.dart'; // Ensure this import is present
import 'package:alarp/features/profile/views/leaderboard_screen.dart'; // Import the new leaderboard screen
import 'package:alarp/features/profile/views/challenge_history_screen.dart'; // Import the new history screen
import 'package:alarp/features/onboarding/splash_screen.dart'; // Import SplashScreen
import '../../features/challenge/views/challenge_results_screen.dart'; // Import the new screen
import 'package:alarp/features/auth/views/sign_in_screen.dart'; // Import Sign In Screen
import 'package:alarp/features/auth/views/sign_up_screen.dart'; // Import Sign Up Screen
import 'package:alarp/features/auth/views/sign_up_complete_screen.dart'; // Import Sign Up Complete Screen
// Hide authStateChangesProvider from this import to avoid conflict
import 'package:alarp/features/auth/controllers/auth_controller.dart'
    hide authStateChangesProvider;
import 'package:alarp/core/providers/supabase_providers.dart'; // Import Supabase providers (contains the needed authStateChangesProvider)
import 'package:alarp/features/auth/views/get_started_screen.dart';
import 'package:alarp/features/auth/views/check_email_screen.dart'; // Import the new screen
import 'package:alarp/features/auth/views/verify_code_screen.dart'; // Import the new screen

// Define route paths
class AppRoutes {
  static const splash = '/splash'; // New splash route
  static const getStarted = '/get_started'; // Add get started route
  static const signIn = '/signin'; // New sign in route
  static const signUp = '/signup'; // New sign up route
  static const checkEmail = '/check-email'; // New route for check email screen
  static const verifyCode = '/verify-code'; // New route for OTP verification
  static const signUpComplete =
      '/signup-complete'; // New route for sign up complete
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
  // Define absolute paths for challenge start and active screens
  static const challengeStart = '/challenge/start/:challengeId';
  static const challengeActivePath = '/challenge/active/:challengeId';
  static const challengeResults =
      '/challenge/results/:challengeId'; // Make absolute
  static const profile = '/profile';
  static const settings = '/settings';
  static const editProfile = '/profile/edit'; // Add edit profile route
  static const skeletonViewer = '/skeleton'; // New route for skeleton viewer
  static const recentPracticeList = '/recent-practice';
  static const leaderboard = '/profile/leaderboard';
  static const challengeHistory = '/profile/challenge-history';
  static const flashcards = '/flashcards';
  static const bookmarks = '/profile/bookmarks';
  static const speedRun = '/challenge/speed-run';
  static const survival = '/challenge/survival';
  static const regionMaster = '/challenge/region-master';
  static const regionMasterGame = '/challenge/region-master/:regionId';

  static String regionMasterGameRoute(String regionId) =>
      regionMasterGame.replaceFirst(':regionId', regionId);

  // Helper method to build the full path for challenge start
  static String challengeStartRoute(String challengeId) =>
      challengeStart.replaceFirst(':challengeId', challengeId);

  // Helper method to build the full path for challenge active
  static String challengeActive(String challengeId) =>
      challengeActivePath.replaceFirst(':challengeId', challengeId);

  // Helper method to build the full path for challenge results
  static String challengeResultsRoute(String challengeId) =>
      challengeResults.replaceFirst(':challengeId', challengeId);
}

// Private navigator keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  // Listen to the authentication status
  final authState = ref.watch(
    authStatusProvider,
  ); // Use the simple boolean provider

  return GoRouter(
    initialLocation: AppRoutes.splash, // Set splash as initial location
    navigatorKey: _rootNavigatorKey,
    redirect: (BuildContext context, GoRouterState state) {
      final currentLocation = state.matchedLocation;
      final loggedIn = authState; // Boolean: Is the user authenticated?

      // Define sets of routes for easier checking
      final publicRoutes = {AppRoutes.splash, AppRoutes.getStarted};
      final authRoutes = {
        AppRoutes.signIn,
        AppRoutes.signUp,
        AppRoutes.verifyCode,
      };
      // Note: AppRoutes.signUpComplete is handled implicitly below

      print('GoRouter Redirect: Current=$currentLocation, loggedIn=$loggedIn');

      // 1. Always allow splash and get started screens
      if (publicRoutes.contains(currentLocation)) {
        print('GoRouter Redirect: Allowing public route: $currentLocation');
        return null;
      }

      // 2. Handle based on authentication state
      if (loggedIn) {
        // User is logged in
        print('GoRouter Redirect: User is logged in.');
        // If logged-in user tries to access auth routes, redirect to home
        if (authRoutes.contains(currentLocation)) {
          print(
            'GoRouter Redirect: Logged in user accessing auth route ($currentLocation), redirecting to home.',
          );
          return AppRoutes.home;
        }
        // Otherwise (accessing home, profile, learn, practice, challenge, signup-complete, etc.), allow access
        print(
          'GoRouter Redirect: Logged in user allowed access to: $currentLocation',
        );
        return null;
      } else {
        // User is NOT logged in
        print('GoRouter Redirect: User is NOT logged in.');
        // Allow access to the standard authentication flow routes
        if (authRoutes.contains(currentLocation)) {
          print(
            'GoRouter Redirect: Not logged in, allowing access to auth route: $currentLocation',
          );
          return null;
        }
        // If a non-logged-in user tries to access signup-complete or any other protected route, redirect to sign in
        print(
          'GoRouter Redirect: Not logged in, attempting to access restricted route ($currentLocation), redirecting to sign in.',
        );
        return AppRoutes.signIn; // Redirect all other non-logged-in attempts
      }
    },
    refreshListenable: GoRouterRefreshStream(
      // Use the one from supabase_providers
      ref.watch(authStateChangesProvider.stream),
    ), // Refresh router on auth changes
    routes: [
      // Add Splash Screen Route (top-level, outside shell)
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // Add Get Started Screen Route (top-level, outside shell)
      GoRoute(
        path: AppRoutes.getStarted,
        builder: (context, state) => const GetStartedScreen(),
      ),
      // Add Sign In Route (top-level)
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      // Add Sign Up Route (top-level)
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      // Add Check Email Route (top-level)
      GoRoute(
        path: AppRoutes.checkEmail,
        builder: (context, state) {
          // Retrieve the email passed as an extra parameter
          final email = state.extra as String?;
          return CheckEmailScreen(email: email);
        },
      ),
      // Add Verify Code Route (top-level)
      GoRoute(
        path: AppRoutes.verifyCode,
        builder: (context, state) {
          // Retrieve the email passed as an extra parameter
          final email = state.extra as String?;
          // Ensure email is passed, otherwise redirect or show error
          if (email == null) {
            // Maybe redirect to signup or show an error screen
            return const Scaffold(
              body: Center(
                child: Text('Error: Email missing for verification.'),
              ),
            );
          }
          return VerifyCodeScreen(email: email);
        },
      ),
      // Add Sign Up Complete Route (top-level)
      GoRoute(
        path: AppRoutes.signUpComplete,
        builder: (context, state) => const SignUpCompleteScreen(),
      ),
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
      GoRoute(
        path: AppRoutes.leaderboard,
        builder: (context, state) => const LeaderboardScreen(),
      ),
      // Add the new Challenge History route here (outside the ShellRoute)
      GoRoute(
        path: AppRoutes.challengeHistory,
        builder: (context, state) => const ChallengeHistoryScreen(),
      ),
      // Flashcard Screen (outside ShellRoute)
      GoRoute(
        path: AppRoutes.flashcards,
        builder: (context, state) => const FlashcardScreen(),
      ),
      GoRoute(
        path: AppRoutes.speedRun,
        builder: (context, state) => const SpeedRunScreen(),
      ),
      GoRoute(
        path: AppRoutes.survival,
        builder: (context, state) => const SurvivalScreen(),
      ),
      GoRoute(
        path: AppRoutes.regionMaster,
        builder: (context, state) => const RegionMasterScreen(),
      ),
      GoRoute(
        path: AppRoutes.regionMasterGame,
        builder: (context, state) {
          final regionId = state.pathParameters['regionId'];
          return SpeedRunScreen(regionId: regionId);
        },
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
      // Challenge Start Screen (outside ShellRoute) - Use absolute path
      GoRoute(
        path: AppRoutes.challengeStart, // Use the absolute path constant
        builder: (context, state) {
          final challengeId = state.pathParameters['challengeId']!;
          final challenge = Challenge.getChallengeById(challengeId);

          // Handle case where challenge is not found
          if (challenge == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Text('Challenge with ID \'$challengeId\' not found.'),
              ),
            );
          }

          // Override the provider for this specific route
          return ProviderScope(
            overrides: [
              currentChallengeProvider.overrideWithValue(challenge),
            ], // Now safe
            child: ChallengeStartScreen(challengeId: challengeId),
          );
        },
      ),
      // Challenge Active Screen (outside ShellRoute) - Use absolute path
      GoRoute(
        path: AppRoutes.challengeActivePath, // Use the absolute path constant
        builder: (context, state) {
          final challengeId = state.pathParameters['challengeId']!;
          final challenge = Challenge.getChallengeById(challengeId);

          // Handle case where challenge is not found
          if (challenge == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Text('Challenge with ID \'$challengeId\' not found.'),
              ),
            );
          }

          // Override the provider for this specific route
          return ProviderScope(
            overrides: [
              activeChallengeProvider.overrideWithValue(challenge),
            ], // Now safe
            child: ChallengeActiveScreen(challengeId: challengeId),
          );
        },
      ),
      // NEW: Challenge Results Screen (Top-Level)
      GoRoute(
        path: AppRoutes.challengeResults, // Use absolute path
        name: AppRoutes.challengeResults, // Assign name for goNamed
        builder: (context, state) {
          final challengeId = state.pathParameters['challengeId']!;
          final challenge = Challenge.getChallengeById(challengeId);

          // Handle case where challenge is not found
          if (challenge == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Text('Challenge with ID \'$challengeId\' not found.'),
              ),
            );
          }

          // Override the provider for this specific route
          // The results screen needs this to get challenge details like title
          // and to access the correct controller instance via challengeControllerProvider(challenge)
          return ProviderScope(
            overrides: [activeChallengeProvider.overrideWithValue(challenge)],
            child: const ChallengeResultsScreen(),
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
                    path: AppRoutes.learnLesson,
                    builder: (context, state) {
                      final lessonId = state.pathParameters['bodyPartId']!;
                      return LearnLessonScreen(lessonId: lessonId);
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
                path: AppRoutes.practiceRegionDetail,
                builder: (context, state) {
                  final regionId = state.pathParameters['regionId']!;
                  final region = BodyRegions.getRegionById(regionId);
                  return RegionDetailScreen(region: region);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.challenge,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: ChallengeScreen()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: ProfileScreen()),
          ),
          GoRoute(
            path: AppRoutes.bookmarks,
            builder: (context, state) => const BookmarksScreen(),
          ),
          GoRoute(
            path: AppRoutes.editProfile,
            builder: (context, state) => const EditProfileScreen(),
          ),
        ],
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Page not found: ${state.error}')),
        ),
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
