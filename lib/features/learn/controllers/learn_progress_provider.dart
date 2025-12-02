import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Simple provider to access SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// StateNotifier to manage the list of completed lesson IDs
class LearnProgressNotifier extends StateNotifier<List<String>> {
  final SharedPreferences _prefs;
  static const _key = 'completed_lessons';

  LearnProgressNotifier(this._prefs) : super([]) {
    _loadProgress();
  }

  void _loadProgress() {
    final completed = _prefs.getStringList(_key) ?? [];
    state = completed;
  }

  Future<void> markLessonCompleted(String lessonId) async {
    if (!state.contains(lessonId)) {
      final newState = [...state, lessonId];
      state = newState;
      await _prefs.setStringList(_key, newState);
    }
  }

  bool isLessonCompleted(String lessonId) {
    return state.contains(lessonId);
  }

  int get completedCount => state.length;
}

final learnProgressProvider =
    StateNotifierProvider<LearnProgressNotifier, List<String>>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return LearnProgressNotifier(prefs);
    });
