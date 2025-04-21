import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:alarp/core/providers/supabase_providers.dart'; // For supabaseClientProvider and userIdProvider

/// Datasource responsible for direct interactions with Supabase
/// regarding user profiles.
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
}

// Provider for the SupabaseProfileDataSource
final supabaseProfileDataSourceProvider = Provider<SupabaseProfileDataSource>((
  ref,
) {
  final client = ref.watch(supabaseClientProvider);
  final userId = ref.watch(userIdProvider); // Get the current user's ID
  return SupabaseProfileDataSource(client, userId);
});
