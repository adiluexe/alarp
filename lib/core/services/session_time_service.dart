import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/data/repositories/profile_repository.dart';
import 'dart:developer' as developer;

/// Provider for the SessionTimeService
final sessionTimeServiceProvider = Provider<SessionTimeService>((ref) {
  return SessionTimeService(ref);
});

/// Tracks the current session's time and syncs it to Supabase on pause/close.
class SessionTimeService with WidgetsBindingObserver {
  final Ref _ref;
  DateTime? _sessionStartTime;
  int _unsyncedSeconds = 0;

  SessionTimeService(this._ref) {
    WidgetsBinding.instance.addObserver(this);
    _startSession();
  }

  void _startSession() {
    _sessionStartTime = DateTime.now();
    developer.log(
      'Session started at $_sessionStartTime',
      name: 'SessionTimeService',
    );
  }

  Future<void> _endSessionAndSync() async {
    if (_sessionStartTime == null) return;
    final now = DateTime.now();
    final sessionSeconds = now.difference(_sessionStartTime!).inSeconds;
    if (sessionSeconds > 0) {
      _unsyncedSeconds += sessionSeconds;
      await _incrementSupabaseTime(_unsyncedSeconds);
      _unsyncedSeconds = 0;
    }
    developer.log(
      'Session ended. Duration: $sessionSeconds seconds',
      name: 'SessionTimeService',
    );
    _sessionStartTime = null;
  }

  Future<void> _incrementSupabaseTime(int seconds) async {
    try {
      final profileRepository = _ref.read(profileRepositoryProvider);
      // Call your Supabase increment function here (replace with your actual RPC call)
      await profileRepository.incrementAppTime(seconds);
      developer.log(
        'Incremented Supabase app time by $seconds seconds',
        name: 'SessionTimeService',
      );
    } catch (e, s) {
      developer.log(
        'Error incrementing Supabase app time: $e',
        error: e,
        stackTrace: s,
        name: 'SessionTimeService',
      );
      // If failed, keep _unsyncedSeconds for next attempt
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    developer.log(
      'App lifecycle state changed: $state',
      name: 'SessionTimeService',
    );
    switch (state) {
      case AppLifecycleState.resumed:
        _startSession();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _endSessionAndSync();
        break;
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _endSessionAndSync();
    developer.log('SessionTimeService disposed.', name: 'SessionTimeService');
  }
}
