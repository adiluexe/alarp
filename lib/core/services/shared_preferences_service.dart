import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Keys for shared preferences
class PrefKeys {
  static const String dailyForegroundSeconds = 'daily_foreground_seconds';
  static const String lastRecordedDate =
      'last_recorded_date'; // Store as ISO 8601 String (yyyy-MM-dd)
  static const String streakTriggeredToday = 'streak_triggered_today';
  static const String totalAppTimeSeconds = 'total_app_time_seconds';
}

class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  // --- Daily Streak Related ---

  int getDailyForegroundSeconds() {
    return _prefs.getInt(PrefKeys.dailyForegroundSeconds) ?? 0;
  }

  Future<void> setDailyForegroundSeconds(int seconds) async {
    await _prefs.setInt(PrefKeys.dailyForegroundSeconds, seconds);
  }

  String? getLastRecordedDateString() {
    return _prefs.getString(PrefKeys.lastRecordedDate);
  }

  Future<void> setLastRecordedDateString(String dateString) async {
    await _prefs.setString(PrefKeys.lastRecordedDate, dateString);
  }

  bool getStreakTriggeredToday() {
    return _prefs.getBool(PrefKeys.streakTriggeredToday) ?? false;
  }

  Future<void> setStreakTriggeredToday(bool triggered) async {
    await _prefs.setBool(PrefKeys.streakTriggeredToday, triggered);
  }

  // --- Total App Time ---

  int getTotalAppTimeSeconds() {
    return _prefs.getInt(PrefKeys.totalAppTimeSeconds) ?? 0;
  }

  Future<void> setTotalAppTimeSeconds(int seconds) async {
    await _prefs.setInt(PrefKeys.totalAppTimeSeconds, seconds);
  }

  // --- Utility ---
  Future<void> clearAll() async {
    // Useful for testing or logout
    await _prefs.clear();
  }
}

// Provider to asynchronously get SharedPreferences instance
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

// Provider for the SharedPreferencesService
final sharedPreferencesServiceProvider = Provider<SharedPreferencesService?>((
  ref,
) {
  // Use .when to handle the async loading of SharedPreferences
  final prefsAsyncValue = ref.watch(sharedPreferencesProvider);
  return prefsAsyncValue.when(
    data: (prefs) => SharedPreferencesService(prefs),
    loading: () => null, // Return null while loading
    error: (err, stack) {
      // Handle error, maybe log it
      print("Error loading SharedPreferences: $err");
      return null;
    },
  );
});
