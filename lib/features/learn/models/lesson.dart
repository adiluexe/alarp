import 'package:flutter/foundation.dart';

@immutable
class Lesson {
  final String id;
  final String title;
  final String bodyRegion;
  final String projectionName;
  final String content; // Markdown content
  final String? imageUrl; // Optional image URL/path
  final String? modelPath; // Optional 3D model path
  final List<QuizQuestion> quizQuestions; // List of quiz questions
  final List<String>
  clinicalCriteria; // List of clinical criteria for checklist

  const Lesson({
    required this.id,
    required this.title,
    required this.bodyRegion,
    required this.projectionName,
    required this.content,
    this.imageUrl,
    this.modelPath,
    this.quizQuestions = const [],
    this.clinicalCriteria = const [],
  });

  // Basic copyWith for immutability
  Lesson copyWith({
    String? id,
    String? title,
    String? bodyRegion,
    String? projectionName,
    String? content,
    String? imageUrl,
    String? modelPath,
    List<QuizQuestion>? quizQuestions,
    List<String>? clinicalCriteria,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      bodyRegion: bodyRegion ?? this.bodyRegion,
      projectionName: projectionName ?? this.projectionName,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      modelPath: modelPath ?? this.modelPath,
      quizQuestions: quizQuestions ?? this.quizQuestions,
      clinicalCriteria: clinicalCriteria ?? this.clinicalCriteria,
    );
  }

  // Basic equality and hashCode
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lesson &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          bodyRegion == other.bodyRegion &&
          projectionName == other.projectionName &&
          content == other.content &&
          imageUrl == other.imageUrl &&
          modelPath == other.modelPath &&
          listEquals(quizQuestions, other.quizQuestions) &&
          listEquals(clinicalCriteria, other.clinicalCriteria);

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      bodyRegion.hashCode ^
      projectionName.hashCode ^
      content.hashCode ^
      imageUrl.hashCode ^
      modelPath.hashCode ^
      quizQuestions.hashCode ^
      clinicalCriteria.hashCode;
}

@immutable
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizQuestion &&
          runtimeType == other.runtimeType &&
          question == other.question &&
          listEquals(options, other.options) &&
          correctIndex == other.correctIndex &&
          explanation == other.explanation;

  @override
  int get hashCode =>
      question.hashCode ^
      options.hashCode ^
      correctIndex.hashCode ^
      explanation.hashCode;
}
