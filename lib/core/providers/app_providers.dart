import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to track if the initial splash screen has completed.
final isSplashFinishedProvider = StateProvider<bool>((ref) => false);
