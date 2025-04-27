import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/data/repositories/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

// Provider for the AppLifecycleService
final appLifecycleServiceProvider = Provider<AppLifecycleService>((ref) {
  return AppLifecycleService(ref);
});

class AppLifecycleService with WidgetsBindingObserver {
  final Ref _ref;
  Timer? _timer;
  int _accumulatedSeconds = 0;
  static const String _prefsKey = 'accumulatedAppTimeSeconds';
  static const int _syncIntervalSeconds = 60; // Sync every 60 seconds

  AppLifecycleService(this._ref) {
    WidgetsBinding.instance.addObserver(this);
    _loadAccumulatedTime();
    _startTimer();
  }

  // Load accumulated time from SharedPreferences
  Future<void> _loadAccumulatedTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _accumulatedSeconds = prefs.getInt(_prefsKey) ?? 0;
      developer.log(
        'Loaded accumulated app time: $_accumulatedSeconds seconds',
        name: 'AppLifecycleService',
      );
    } catch (e) {
      developer.log(
        'Error loading accumulated time: $e',
        error: e,
        name: 'AppLifecycleService',
      );
    }
  }

  // Save accumulated time to SharedPreferences
  Future<void> _saveAccumulatedTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefsKey, _accumulatedSeconds);
      developer.log(
        'Saved accumulated app time: $_accumulatedSeconds seconds',
        name: 'AppLifecycleService',
      );
    } catch (e) {
      developer.log(
        'Error saving accumulated time: $e',
        error: e,
        name: 'AppLifecycleService',
      );
    }
  }

  // Start the timer to increment accumulated time
  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _accumulatedSeconds++;
      // Sync with backend periodically
      if (_accumulatedSeconds % _syncIntervalSeconds == 0) {
        _syncWithBackend();
      }
    });
    developer.log('App usage timer started.', name: 'AppLifecycleService');
  }

  // Stop the timer
  void _stopTimer() {
    _timer?.cancel();
    developer.log('App usage timer stopped.', name: 'AppLifecycleService');
  }

  // Sync accumulated time with the backend
  Future<void> _syncWithBackend() async {
    try {
      final profileRepository = _ref.read(profileRepositoryProvider);
      await profileRepository.updateTotalAppTime(_accumulatedSeconds);
      developer.log(
        'Synced accumulated time with backend: $_accumulatedSeconds seconds',
        name: 'AppLifecycleService',
      );
      // Optionally, save locally after successful sync as well
      await _saveAccumulatedTime();
    } catch (e) {
      developer.log(
        'Error syncing accumulated time with backend: $e',
        error: e,
        name: 'AppLifecycleService',
      );
      // Decide if local save should happen even if backend sync fails
      // await _saveAccumulatedTime(); // Save locally regardless?
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    developer.log(
      'App lifecycle state changed: $state',
      name: 'AppLifecycleService',
    );
    switch (state) {
      case AppLifecycleState.resumed:
        _loadAccumulatedTime(); // Reload time when resuming
        _startTimer();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden: // Handle hidden state as well
        _stopTimer();
        _syncWithBackend(); // Sync time when app goes into background/closes
        _saveAccumulatedTime(); // Ensure local save on exit/pause
        break;
    }
  }

  // Method to be called when user performs a significant activity (e.g., completes challenge/practice)
  // This method is now redundant for streak checking as it's handled directly
  // in the datasource methods for adding practice/challenge results.
  // It might still be useful for other "activity recorded" logic if needed later.
  // Future<void> recordActivity() async {
  //   developer.log('User activity recorded.', name: 'AppLifecycleService');
  //   // The streak check is now handled elsewhere.
  //   // try {
  //   //   final profileRepository = _ref.read(profileRepositoryProvider);
  //   //   await profileRepository.recordActivityAndCheckStreak(); // <-- THIS LINE CAUSED THE ERROR
  //   //   developer.log('Streak check triggered by activity.', name: 'AppLifecycleService');
  //   // } catch (e) {
  //   //   developer.log(
  //   //     'Error triggering streak check: $e',
  //   //     error: e,
  //   //     name: 'AppLifecycleService',
  //   //   );
  //   // }
  // }

  // Dispose method to clean up resources
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopTimer();
    // Perform a final sync and save before disposing
    _syncWithBackend();
    _saveAccumulatedTime();
    developer.log('AppLifecycleService disposed.', name: 'AppLifecycleService');
  }
}
