import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/data/datasources/supabase_profile_datasource.dart'; // Assuming datasource location

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
}
