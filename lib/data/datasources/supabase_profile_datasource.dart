import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:alarp/core/providers/supabase_providers.dart'; // For supabaseClientProvider, userIdProvider, and userProfileProvider
import 'package:alarp/features/challenge/models/challenge_attempt.dart'; // Import ChallengeAttempt
import 'dart:developer' as developer; // Use developer log

// Define a type for leaderboard entry data using a record
typedef LeaderboardEntry = ({int rank, String username, int score});

/// Datasource responsible for direct interactions with Supabase
/// regarding user profiles and related data like scores and challenge history.
class SupabaseProfileDataSource {
  final SupabaseClient _client;
  final String? _userId; // Get current user ID
  final Ref _ref; // Add Ref

  SupabaseProfileDataSource(
    this._client,
    this._userId,
    this._ref,
  ); // Modify constructor

  // Removed callIncrementStreakIfNeeded() - RPC is called directly now

  /// Updates the 'total_app_time_seconds' for the current user in Supabase.
  Future<void> updateTotalAppTime(int totalSeconds) async {
    if (_userId == null) {
      developer.log(
        "User not logged in. Cannot update total app time.",
        name: 'SupabaseProfileDataSource',
      );
      // Optionally throw, but maybe just log and return for this case
      return;
    }
    if (totalSeconds < 0) {
      throw ArgumentError("Total app time cannot be negative.");
    }

    try {
      await _client
          .from('profiles')
          .update({'total_app_time_seconds': totalSeconds})
          .eq('id', _userId);
      developer.log(
        "Total app time updated successfully.",
        name: 'SupabaseProfileDataSource',
      );
    } on PostgrestException catch (e) {
      developer.log(
        "Supabase error updating total app time: ${e.message}",
        error: e,
        name: 'SupabaseProfileDataSource',
      );
      throw Exception("Failed to update total app time: ${e.message}");
    } catch (e) {
      developer.log(
        "Unexpected error updating total app time: $e",
        error: e,
        name: 'SupabaseProfileDataSource',
      );
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
      // 1. Insert into the challenge_history table
      await _client.from('challenge_history').insert({
        'user_id': _userId,
        'challenge_id': challengeId,
        'challenge_title': challengeTitle,
        'score': score,
        'step_results': stepResultsJson, // Store the detailed step results
        // 'completed_at' and 'created_at' have default values in the DB
      });
      developer.log(
        'Challenge history record added successfully',
        name: 'SupabaseProfileDataSource',
      );

      // 2. Call RPC to increment streak
      try {
        await _client.rpc(
          'increment_streak_if_needed',
          params: {
            'p_user_id': _userId,
          }, // Ensure param name matches RPC definition
        );
        developer.log(
          'Streak increment check triggered after challenge submission',
          name: 'SupabaseProfileDataSource',
        );
        // ---> Invalidate the user profile provider to force UI refresh <---
        _ref.invalidate(userProfileProvider);
        developer.log(
          'Invalidated userProfileProvider after challenge submission.',
          name: 'SupabaseProfileDataSource',
        );
      } on PostgrestException catch (e) {
        // Log streak update failure but don't throw; main operation succeeded
        developer.log(
          'Error calling increment_streak_if_needed after challenge: ${e.message}',
          error: e,
          name: 'SupabaseProfileDataSource',
        );
      } catch (e) {
        // Log unexpected streak update failure
        developer.log(
          'Unexpected error calling increment_streak_if_needed after challenge: $e',
          error: e,
          name: 'SupabaseProfileDataSource',
        );
      }

      // Note: Leaderboard RPCs (`get_daily_leaderboard`, `get_user_daily_rank`)
      // are assumed to read from `challenge_history` now or handle aggregation separately.
      // We don't need to interact with `challenge_scores` here anymore.
    } on PostgrestException catch (e) {
      developer.log(
        'Error submitting challenge history: ${e.message}',
        error: e,
        name: 'SupabaseProfileDataSource',
      );
      // Provide more specific error context
      throw Exception(
        "Failed to submit challenge history record: ${e.message}",
      );
    } catch (e) {
      developer.log(
        'Unexpected error submitting challenge history: $e',
        error: e,
        name: 'SupabaseProfileDataSource',
      );
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
      developer.log(
        "Warning: Unexpected response format from get_daily_leaderboard: $response",
        name: 'SupabaseProfileDataSource',
      );
      return [];
    } on PostgrestException catch (e) {
      developer.log(
        "Supabase error fetching leaderboard: ${e.message}",
        error: e,
        name: 'SupabaseProfileDataSource',
      );
      throw Exception("Failed to fetch leaderboard: ${e.message}");
    } catch (e) {
      developer.log(
        "Unexpected error fetching leaderboard: $e",
        error: e,
        name: 'SupabaseProfileDataSource',
      );
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
      developer.log(
        "User not logged in. Cannot get rank.",
        name: 'SupabaseProfileDataSource',
      );
      // Return null as rank is not applicable for non-logged-in users
      return null;
    }
    try {
      final response = await _client.rpc(
        'get_user_daily_rank',
        params: {
          'p_challenge_id': challengeId,
          'user_id': _userId,
        }, // Pass user ID
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
      developer.log(
        "Supabase error fetching user rank: ${e.message}",
        error: e,
        name: 'SupabaseProfileDataSource',
      );
      // Return null on error, as the rank is unavailable
      return null;
    } catch (e) {
      developer.log(
        "Unexpected error fetching user rank: $e",
        error: e,
        name: 'SupabaseProfileDataSource',
      );
      // Return null on unexpected errors
      return null;
    }
  }

  /// Fetches the profile data for the current user.
  /// Returns a map containing profile data or null if not found or error.
  Future<Map<String, dynamic>?> getProfile() async {
    if (_userId == null) {
      developer.log(
        "User not logged in. Cannot get profile.",
        name: 'SupabaseProfileDataSource',
      );
      return null;
    }
    try {
      final response =
          await _client
              .from('profiles')
              .select() // Select all columns
              .eq('id', _userId)
              .maybeSingle(); // Use maybeSingle to return null if no row matches

      if (response == null) {
        developer.log(
          "No profile found for user $_userId",
          name: 'SupabaseProfileDataSource',
        );
        return null;
      }
      // Explicitly cast to Map<String, dynamic>
      return response as Map<String, dynamic>;
    } on PostgrestException catch (e) {
      developer.log(
        "Supabase error fetching profile: ${e.message}",
        error: e,
        name: 'SupabaseProfileDataSource',
      );
      return null; // Return null on error
    } catch (e) {
      developer.log(
        "Unexpected error fetching profile: $e",
        error: e,
        name: 'SupabaseProfileDataSource',
      );
      return null; // Return null on unexpected errors
    }
  }

  /// Fetches the challenge history for the current user from 'challenge_history'.
  Future<List<ChallengeAttempt>> getChallengeHistory({int limit = 20}) async {
    if (_userId == null) {
      developer.log(
        "User not logged in. Cannot get challenge history.",
        name: 'SupabaseProfileDataSource',
      );
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
      developer.log(
        "Supabase error fetching challenge history: ${e.message}",
        error: e,
        name: 'SupabaseProfileDataSource',
      );
      throw Exception("Failed to fetch challenge history: ${e.message}");
    } catch (e) {
      developer.log(
        "Unexpected error fetching challenge history: $e",
        error: e,
        name: 'SupabaseProfileDataSource',
      );
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
      developer.log(
        "Supabase error fetching all-time leaderboard: ${e.message}",
        error: e,
        name: 'SupabaseProfileDataSource',
      );
      throw Exception("Failed to fetch all-time leaderboard: ${e.message}");
    } catch (e) {
      developer.log(
        "Unexpected error fetching all-time leaderboard: ${e}",
        error: e,
        name: 'SupabaseProfileDataSource',
      );
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
  final userId = ref.watch(userIdProvider);
  // Pass ref to the constructor
  return SupabaseProfileDataSource(client, userId, ref);
});
