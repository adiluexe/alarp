import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/data/repositories/profile_repository.dart';
import 'dart:developer' as developer;

// Provider for the AppLifecycleService
final appLifecycleServiceProvider = Provider<AppLifecycleService>((ref) {
  return AppLifecycleService(ref);
});

class AppLifecycleService with WidgetsBindingObserver {
  final Ref _ref;

  AppLifecycleService(this._ref) {
    WidgetsBinding.instance.addObserver(this);
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
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden: // Handle hidden state as well
        break;
    }
  }

  // Dispose method to clean up resources
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    developer.log('AppLifecycleService disposed.', name: 'AppLifecycleService');
  }
}
