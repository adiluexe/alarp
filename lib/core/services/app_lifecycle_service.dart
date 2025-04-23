import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:alarp/core/services/shared_preferences_service.dart';
import 'package:alarp/data/repositories/profile_repository.dart';

const int DAILY_USAGE_THRESHOLD_SECONDS = 900; // 15 minutes

class AppLifecycleService with WidgetsBindingObserver {
  // Use Ref instead of the deprecated Reader
  final Ref _ref;
  DateTime? _resumeTime;

  // Update constructor to accept Ref
  AppLifecycleService(this._ref) {
    WidgetsBinding.instance.addObserver(this);
    _initializeTimeTracking(); // Call the new initialization method
  }

  // New method to handle initialization logic
  Future<void> _initializeTimeTracking() async {
    await _checkDateAndResetIfNeeded(); // Check date first
    await _loadInitialTotalTime(); // Then load initial time
  }

  // Helper to get today's date as a string
  String _getTodayDateString() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  // Checks if the date has changed and resets daily counters if needed
  Future<void> _checkDateAndResetIfNeeded() async {
    // Use _ref.read instead of _read()
    final prefsService = _ref.read(sharedPreferencesServiceProvider);
    if (prefsService == null) return; // Prefs not ready

    final todayString = _getTodayDateString();
    final lastDateString = prefsService.getLastRecordedDateString();

    if (lastDateString != todayString) {
      print("New day detected. Resetting daily counters.");
      await prefsService.setDailyForegroundSeconds(0);
      await prefsService.setStreakTriggeredToday(false);
      await prefsService.setLastRecordedDateString(todayString);
      // Optionally: Sync total time here if needed on date change
      // await _syncTotalAppTime();
    }
  }

  // New method to load total time from Supabase on startup
  Future<void> _loadInitialTotalTime() async {
    final prefsService = _ref.read(sharedPreferencesServiceProvider);
    if (prefsService == null) return;

    try {
      final profileData =
          await _ref.read(profileRepositoryProvider).getProfile();
      final serverTotalSeconds =
          profileData?['total_app_time_seconds'] as int? ?? 0;

      // Update SharedPreferences with the value from the server
      await prefsService.setTotalAppTimeSeconds(serverTotalSeconds);
      print(
        "Initialized local total app time from server: $serverTotalSeconds seconds",
      );
    } catch (e) {
      print("Error loading initial total app time from server: $e");
      // Optionally load local value as fallback?
      // final localTotalSeconds = prefsService.getTotalAppTimeSeconds();
      // print("Using local fallback total time: $localTotalSeconds seconds");
    }
  }

  // Syncs the locally tracked total app time to Supabase
  Future<void> _syncTotalAppTime() async {
    final prefsService = _ref.read(sharedPreferencesServiceProvider);
    if (prefsService == null) return;

    final localTotalSeconds = prefsService.getTotalAppTimeSeconds();

    // Use the actual repository method now
    try {
      // Read the repository provider using _ref
      await _ref
          .read(profileRepositoryProvider)
          .updateTotalAppTime(localTotalSeconds);
      print("Synced total app time: $localTotalSeconds seconds");
    } catch (e) {
      print("Error syncing total app time: $e");
      // Handle error - maybe retry later or log more formally?
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    // Use _ref.read instead of _read()
    final prefsService = _ref.read(sharedPreferencesServiceProvider);
    if (prefsService == null) return; // Prefs not ready

    // Ensure date is current before processing state changes
    await _checkDateAndResetIfNeeded();

    switch (state) {
      case AppLifecycleState.resumed:
        print("App Resumed");
        _resumeTime = DateTime.now();
        break;
      case AppLifecycleState.paused:
        print("App Paused");
        if (_resumeTime != null) {
          final now = DateTime.now();
          final duration = now.difference(_resumeTime!).inSeconds;
          _resumeTime = null; // Reset resume time

          if (duration > 0) {
            // Update Daily Time
            final currentDailySeconds =
                prefsService.getDailyForegroundSeconds();
            final newDailySeconds = currentDailySeconds + duration;
            await prefsService.setDailyForegroundSeconds(newDailySeconds);
            print(
              "Added $duration seconds to daily time. Total today: $newDailySeconds",
            );

            // Update Total Time
            final currentTotalSeconds = prefsService.getTotalAppTimeSeconds();
            final newTotalSeconds = currentTotalSeconds + duration;
            await prefsService.setTotalAppTimeSeconds(newTotalSeconds);
            print("Total app time: $newTotalSeconds seconds");

            // Check Streak Threshold
            final streakTriggered = prefsService.getStreakTriggeredToday();
            if (!streakTriggered &&
                newDailySeconds >= DAILY_USAGE_THRESHOLD_SECONDS) {
              print(
                "Daily usage threshold met ($DAILY_USAGE_THRESHOLD_SECONDS seconds). Triggering streak check.",
              );
              try {
                // Call the repository method to trigger the backend function
                // Use _ref.read instead of _read()
                await _ref
                    .read(profileRepositoryProvider)
                    .recordActivityAndCheckStreak();
                // Mark streak as triggered for today locally
                await prefsService.setStreakTriggeredToday(true);
                print("Streak check triggered successfully for today.");
              } catch (e) {
                print("Error triggering streak check: $e");
                // Handle error (e.g., log, maybe retry later?)
              }
            }

            // Optionally sync total time on pause
            await _syncTotalAppTime();
          }
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden: // Handle newer hidden state if necessary
        // App is inactive or detached, similar to paused for time tracking
        if (_resumeTime != null) {
          final now = DateTime.now();
          final duration = now.difference(_resumeTime!).inSeconds;
          _resumeTime = null; // Reset resume time
          if (duration > 0) {
            // Update times (similar to paused state)
            final currentDailySeconds =
                prefsService.getDailyForegroundSeconds();
            await prefsService.setDailyForegroundSeconds(
              currentDailySeconds + duration,
            );
            final currentTotalSeconds = prefsService.getTotalAppTimeSeconds();
            await prefsService.setTotalAppTimeSeconds(
              currentTotalSeconds + duration,
            );
            print("Added $duration seconds during inactive/detached state.");
            // Sync total time on exit?
            await _syncTotalAppTime();
          }
        }
        break;
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Ensure final time is recorded if app is disposed unexpectedly?
    // This might be complex/unreliable. Syncing on pause/inactive is safer.
    print("AppLifecycleService disposed");
  }
}

// Provider for the AppLifecycleService
final appLifecycleServiceProvider = Provider<AppLifecycleService>((ref) {
  // Pass ref to the constructor
  final service = AppLifecycleService(ref);
  // Ensure dispose is called when the provider is disposed
  ref.onDispose(() => service.dispose());
  return service;
});
