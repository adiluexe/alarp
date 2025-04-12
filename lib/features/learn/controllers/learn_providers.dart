import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lesson.dart';
import '../data/static_lesson_data.dart'; // Import the static data source

/// Provider to fetch a specific lesson's details using its ID.
///
/// Takes the [lessonId] (String) as an argument.
/// Returns the [Lesson] object or null if not found.
final lessonDetailProvider = Provider.family<Lesson?, String>((ref, lessonId) {
  // Retrieve the lesson data from the static source
  final lesson = getLessonFromStaticSource(lessonId);
  return lesson;
});
