import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, List<String>>((ref) {
      return BookmarksNotifier();
    });

class BookmarksNotifier extends StateNotifier<List<String>> {
  BookmarksNotifier() : super([]) {
    _loadBookmarks();
  }

  static const _key = 'bookmarked_lessons';

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList(_key) ?? [];
    state = bookmarks;
  }

  Future<void> toggleBookmark(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    if (state.contains(lessonId)) {
      state = state.where((id) => id != lessonId).toList();
    } else {
      state = [...state, lessonId];
    }
    await prefs.setStringList(_key, state);
  }

  bool isBookmarked(String lessonId) {
    return state.contains(lessonId);
  }
}
