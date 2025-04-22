import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:alarp/core/providers/supabase_providers.dart'; // For supabaseClientProvider and userIdProvider
import 'package:alarp/features/challenge/models/challenge_attempt.dart'; // Import ChallengeAttempt

// Define a type for leaderboard entry data using a record
typedef LeaderboardEntry = ({int rank, String username, int score});

/// Datasource responsible for direct interactions with Supabase
/// regarding user profiles and related data like scores and challenge history.
class SupabaseProfileDataSource {
  final SupabaseClient _client;
  final String? _userId; // Get current user ID

  SupabaseProfileDataSource(this._client, this._userId);

  /// Calls the Supabase RPC function 'increment_streak_if_needed'.
  Future<void> callIncrementStreakIfNeeded() async {
    if (_userId == null) {
      throw Exception("User not logged in. Cannot update streak.");
    }

    try {
      // Call the RPC function, passing the user ID as an argument
      await _client.rpc(
        'increment_streak_if_needed',
        params: {'user_id': _userId},
      );
      // No return value needed based on the function definition
    } on PostgrestException catch (e) {
      // Handle potential Supabase errors (e.g., function not found, RLS issues)
      print("Supabase error calling increment_streak_if_needed: ${e.message}");
      throw Exception("Failed to update daily streak: ${e.message}");
    } catch (e) {
      // Handle other unexpected errors
      print("Unexpected error calling increment_streak_if_needed: $e");
      throw Exception("An unexpected error occurred while updating streak.");
    }
  }

  /// Updates the 'total_app_time_seconds' for the current user in Supabase.
  Future<void> updateTotalAppTime(int totalSeconds) async {
    if (_userId == null) {
      throw Exception("User not logged in. Cannot update total app time.");
    }
    if (totalSeconds < 0) {
      // Basic validation
      print(
        "Warning: Attempted to update total app time with negative value: $totalSeconds",
      );
      return;
    }

    try {
      await _client
          .from('profiles')
          .update({'total_app_time_seconds': totalSeconds})
          .eq('id', _userId); // Update the row matching the current user's ID

      print(
        "Successfully updated total_app_time_seconds to $totalSeconds for user $_userId",
      );
    } on PostgrestException catch (e) {
      print("Supabase error updating total_app_time_seconds: ${e.message}");
      throw Exception("Failed to update total app time: ${e.message}");
    } catch (e) {
      print("Unexpected error updating total_app_time_seconds: $e");
      throw Exception(
        "An unexpected error occurred while updating total app time.",
      );
    }
  }

  /// Submits a challenge attempt to the 'challenge_history' table.
  Future<void> submitChallengeScore(
    String challengeId,
    String challengeTitle,
    int score,
    List<Map<String, dynamic>> stepResultsJson,
  ) async {
    if (_userId == null) {
      throw Exception("User not logged in. Cannot submit score.");
    }
    if (score < 0) {
      throw ArgumentError("Score cannot be negative.");
    }

    try {
      // Insert into the challenge_history table
      await _client.from('challenge_history').insert({
        'user_id': _userId,
        'challenge_id': challengeId,
        'challenge_title': challengeTitle,
        'score': score,
        'step_results': stepResultsJson, // Store the detailed step results
        // 'completed_at' and 'created_at' have default values in the DB
      });

      // Note: Leaderboard RPCs (`get_daily_leaderboard`, `get_user_daily_rank`)
      // are assumed to read from `challenge_history` now or handle aggregation separately.
      // We don't need to interact with `challenge_scores` here anymore.
    } on PostgrestException catch (e) {
      // Provide more specific error context
      throw Exception(
        "Failed to submit challenge history record: ${e.message}",
      );
    } catch (e) {
      throw Exception(
        "An unexpected error occurred while submitting challenge history.",
      );
    }
  }

  /// Fetches the daily leaderboard for a given challenge.
  /// Calls the 'get_daily_leaderboard' RPC function.
  Future<List<LeaderboardEntry>> getDailyLeaderboard(
    String challengeId, {
    int limit = 10, // Default limit matches the RPC function
  }) async {
    try {
      final response = await _client.rpc(
        'get_daily_leaderboard',
        params: {'p_challenge_id': challengeId, 'p_limit': limit},
      );

      // Response is List<dynamic>, each item is Map<String, dynamic>
      if (response is List) {
        return response.map((item) {
          final map = item as Map<String, dynamic>;
          // Use named record fields for clarity and type safety
          return (
            rank: map['rank'] as int? ?? 0, // Provide default if null
            username:
                map['display_name'] as String? ??
                'User', // Use display_name field
            score: map['score'] as int? ?? 0, // Provide default
          );
        }).toList();
      }
      // Return empty list if response is not a list (e.g., error or unexpected format)
      print(
        "Warning: Unexpected response format from get_daily_leaderboard: $response",
      );
      return [];
    } on PostgrestException catch (e) {
      print("Supabase error fetching leaderboard: ${e.message}");
      throw Exception("Failed to fetch leaderboard: ${e.message}");
    } catch (e) {
      print("Unexpected error fetching leaderboard: $e");
      throw Exception(
        "An unexpected error occurred while fetching leaderboard.",
      );
    }
  }

  /// Fetches the current user's rank and score for a given challenge today.
  /// Calls the 'get_user_daily_rank' RPC function.
  /// Returns a record (rank, score) or null if the user hasn't played today or an error occurs.
  Future<({int rank, int score})?> getUserDailyRank(String challengeId) async {
    if (_userId == null) {
      print("User not logged in. Cannot get rank.");
      // Return null as rank is not applicable for non-logged-in users
      return null;
    }
    try {
      final response = await _client.rpc(
        'get_user_daily_rank',
        params: {'p_challenge_id': challengeId},
      );

      // Response is List<dynamic> with 0 or 1 item (Map<String, dynamic>)
      if (response is List && response.isNotEmpty) {
        final map = response.first as Map<String, dynamic>;
        // Use named record fields
        return (
          rank: map['rank'] as int? ?? 0, // Provide default
          score: map['score'] as int? ?? 0, // Provide default
        );
      }
      // User has no rank for this challenge today (empty list returned from RPC)
      return null;
    } on PostgrestException catch (e) {
      print("Supabase error fetching user rank: ${e.message}");
      // Return null on error, as the rank is unavailable
      return null;
    } catch (e) {
      print("Unexpected error fetching user rank: $e");
      // Return null on unexpected errors
      return null;
    }
  }

  /// Fetches the challenge history for the current user from 'challenge_history'.
  Future<List<ChallengeAttempt>> getChallengeHistory({int limit = 20}) async {
    if (_userId == null) {
      print("User not logged in. Cannot get challenge history.");
      return []; // Return empty list for non-logged-in users
    }
    try {
      final response = await _client
          .from('challenge_history') // Fetch from the correct table
          .select() // Select all columns needed by ChallengeAttempt.fromJson
          .eq('user_id', _userId)
          .order('completed_at', ascending: false) // Order by completion time
          .limit(limit);

      // Response is List<Map<String, dynamic>>
      return response.map((json) => ChallengeAttempt.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      print("Supabase error fetching challenge history: ${e.message}");
      throw Exception("Failed to fetch challenge history: ${e.message}");
    } catch (e) {
      print("Unexpected error fetching challenge history: $e");
      throw Exception(
        "An unexpected error occurred while fetching challenge history.",
      );
    }
  }

  /// Fetches the all-time leaderboard for a given challenge.
  /// Uses each user's highest score for the challenge (not sum of all scores).
  /// Fetches first_name and last_name from profiles and displays as 'FirstName, L.'
  Future<List<LeaderboardEntry>> getAllTimeLeaderboard(
    String challengeId, {
    int limit = 10,
  }) async {
    try {
      // Step 1: For each user, get their highest score for this challenge
      final response = await _client
          .from('challenge_history')
          .select('user_id, score')
          .eq('challenge_id', challengeId)
          .order('score', ascending: false)
          .limit(10000); // Get enough rows for aggregation

      // Map user_id to their highest score
      final Map<String, int> userHighScores = {};
      for (final row in response) {
        final userId = row['user_id'] as String;
        final score = row['score'] as int? ?? 0;
        if (!userHighScores.containsKey(userId) ||
            score > userHighScores[userId]!) {
          userHighScores[userId] = score;
        }
      }
      // Sort by score desc and take top N
      final topUsers =
          userHighScores.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
      final topUserIds = topUsers.take(limit).map((e) => e.key).toList();

      // Step 2: Fetch first_name and last_name for top users
      Map<String, Map<String, dynamic>> userNames = {};
      if (topUserIds.isNotEmpty) {
        final profiles = await _client
            .from('profiles')
            .select('id, first_name, last_name')
            .inFilter('id', topUserIds);
        for (final profile in profiles) {
          userNames[profile['id']] = profile;
        }
      }

      // Step 3: Build leaderboard entries
      final leaderboard = <LeaderboardEntry>[];
      for (int i = 0; i < topUsers.length && i < limit; i++) {
        final userId = topUsers[i].key;
        final score = topUsers[i].value;
        final profile = userNames[userId];
        String displayName = 'User';
        if (profile != null) {
          final first = (profile['first_name'] as String?)?.trim() ?? '';
          final last = (profile['last_name'] as String?)?.trim() ?? '';
          displayName =
              first.isNotEmpty
                  ? (last.isNotEmpty
                      ? '$first, ${last[0].toUpperCase()}.'
                      : first)
                  : 'User';
        }
        leaderboard.add((rank: i + 1, username: displayName, score: score));
      }
      return leaderboard;
    } on PostgrestException catch (e) {
      print("Supabase error fetching all-time leaderboard: ${e.message}");
      throw Exception("Failed to fetch all-time leaderboard: ${e.message}");
    } catch (e) {
      print("Unexpected error fetching all-time leaderboard: ${e}");
      throw Exception(
        "An unexpected error occurred while fetching all-time leaderboard.",
      );
    }
  }
}

// Provider for the SupabaseProfileDataSource
final supabaseProfileDataSourceProvider = Provider<SupabaseProfileDataSource>((
  ref,
) {
  final client = ref.watch(supabaseClientProvider);
  final userId = ref.watch(userIdProvider); // Get the current user's ID
  return SupabaseProfileDataSource(client, userId);
});
