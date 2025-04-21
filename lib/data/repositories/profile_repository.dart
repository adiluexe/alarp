import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/data/datasources/supabase_profile_datasource.dart'; // Assuming datasource location

// Import the LeaderboardEntry type defined in the datasource
import 'package:alarp/data/datasources/supabase_profile_datasource.dart'
    show LeaderboardEntry;
// Re-export the type for easier use in controllers and UI
export 'package:alarp/data/datasources/supabase_profile_datasource.dart'
    show LeaderboardEntry;

/// Abstract interface for profile-related data operations.
abstract class ProfileRepository {
  /// Records that the user completed an activity (Practice/Challenge)
  /// and triggers the backend logic to update the daily streak if necessary.
  ///
  /// Throws an exception if the operation fails.
  Future<void> recordActivityAndCheckStreak();

  /// Updates the total accumulated app usage time for the current user.
  ///
  /// [totalSeconds]: The total number of seconds the app has been used.
  /// Throws an exception if the operation fails.
  Future<void> updateTotalAppTime(int totalSeconds);

  /// Submits the score for a completed challenge.
  ///
  /// [challengeId]: Identifier of the challenge (e.g., 'ap_chest_timed').
  /// [score]: The score achieved by the user.
  /// Throws an exception if the operation fails.
  Future<void> submitChallengeScore(String challengeId, int score);

  /// Fetches the top N daily leaderboard entries for a specific challenge.
  ///
  /// [challengeId]: Identifier of the challenge.
  /// [limit]: The maximum number of entries to return (defaults to 10).
  /// Returns a list of LeaderboardEntry records.
  /// Throws an exception if the operation fails.
  Future<List<LeaderboardEntry>> getDailyLeaderboard(
    String challengeId, {
    int limit = 10,
  });

  /// Fetches the current user's rank and score for a specific challenge today.
  ///
  /// [challengeId]: Identifier of the challenge.
  /// Returns a record containing the user's rank and score, or null if
  /// the user hasn't participated in that challenge today or is not logged in.
  /// May return null or throw depending on underlying datasource implementation on error.
  Future<({int rank, int score})?> getUserDailyRank(String challengeId);
}

// Provider for the ProfileRepository implementation
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  // Obtain the datasource (implementation detail)
  final datasource = ref.watch(supabaseProfileDataSourceProvider);
  return SupabaseProfileRepository(datasource); // Return the implementation
});

/// Implementation of ProfileRepository using Supabase.
class SupabaseProfileRepository implements ProfileRepository {
  final SupabaseProfileDataSource _dataSource;

  SupabaseProfileRepository(this._dataSource);

  @override
  Future<void> recordActivityAndCheckStreak() async {
    // Delegate the call to the datasource
    await _dataSource.callIncrementStreakIfNeeded();
  }

  @override
  Future<void> updateTotalAppTime(int totalSeconds) async {
    await _dataSource.updateTotalAppTime(totalSeconds);
  }

  @override
  Future<void> submitChallengeScore(String challengeId, int score) {
    // Delegate the call to the datasource
    return _dataSource.submitChallengeScore(challengeId, score);
  }

  @override
  Future<List<LeaderboardEntry>> getDailyLeaderboard(
    String challengeId, {
    int limit = 10,
  }) {
    // Delegate the call to the datasource
    return _dataSource.getDailyLeaderboard(challengeId, limit: limit);
  }

  @override
  Future<({int rank, int score})?> getUserDailyRank(String challengeId) {
    // Delegate the call to the datasource
    return _dataSource.getUserDailyRank(challengeId);
  }
}
