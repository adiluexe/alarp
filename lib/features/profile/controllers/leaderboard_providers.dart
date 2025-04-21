import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/data/repositories/profile_repository.dart'; // Access repository and LeaderboardEntry type

// Provider to fetch the daily leaderboard list for a given challenge ID
// It takes the challengeId as a parameter (family).
final dailyLeaderboardProvider = FutureProvider.family<
  List<LeaderboardEntry>,
  String
>(
  (ref, challengeId) async {
    print(
      "[LeaderboardProvider] Fetching leaderboard for challenge: $challengeId",
    );
    try {
      // Watch the repository provider to get an instance of ProfileRepository
      final repository = ref.watch(profileRepositoryProvider);
      // Call the repository method to fetch the leaderboard data
      final leaderboardData = await repository.getDailyLeaderboard(
        challengeId,
        limit: 10,
      );
      print(
        "[LeaderboardProvider] Fetched data for $challengeId: ${leaderboardData.length} entries",
      );
      // Optional: Print the actual data if needed for deeper debugging
      // leaderboardData.forEach((entry) => print("[LeaderboardProvider] Entry: Rank ${entry.rank}, Name ${entry.username}, Score ${entry.score}"));
      return leaderboardData;
    } catch (e, stackTrace) {
      print(
        "[LeaderboardProvider] Error fetching leaderboard for $challengeId: $e",
      );
      print("[LeaderboardProvider] Stack Trace: $stackTrace");
      // Re-throw the error so the UI can handle the error state
      rethrow;
    }
  },
  name: 'dailyLeaderboardProvider', // Optional: Name for debugging tools
);

// Provider to fetch the current user's rank and score for a given challenge ID today.
// It takes the challengeId as a parameter (family).
// Returns a nullable record: ({int rank, int score})?
final userDailyRankProvider = FutureProvider.family<
  ({int rank, int score})?,
  String
>(
  (ref, challengeId) async {
    print("[UserRankProvider] Fetching user rank for challenge: $challengeId");
    try {
      // Watch the repository provider
      final repository = ref.watch(profileRepositoryProvider);
      // Call the repository method to fetch the user's rank
      final rankData = await repository.getUserDailyRank(challengeId);
      if (rankData != null) {
        print(
          "[UserRankProvider] Fetched rank for $challengeId: Rank ${rankData.rank}, Score ${rankData.score}",
        );
      } else {
        print(
          "[UserRankProvider] No rank found for user for challenge $challengeId today.",
        );
      }
      return rankData;
    } catch (e, stackTrace) {
      print("[UserRankProvider] Error fetching user rank for $challengeId: $e");
      print("[UserRankProvider] Stack Trace: $stackTrace");
      // Depending on desired behavior, you might return null or rethrow
      // Returning null might be suitable if rank is optional display
      return null;
      // rethrow; // Or rethrow if the error should propagate to UI
    }
  },
  name: 'userDailyRankProvider', // Optional: Name for debugging
);
