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

  const Lesson({
    required this.id,
    required this.title,
    required this.bodyRegion,
    required this.projectionName,
    required this.content,
    this.imageUrl,
    this.modelPath,
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
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      bodyRegion: bodyRegion ?? this.bodyRegion,
      projectionName: projectionName ?? this.projectionName,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      modelPath: modelPath ?? this.modelPath,
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
          modelPath == other.modelPath;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      bodyRegion.hashCode ^
      projectionName.hashCode ^
      content.hashCode ^
      imageUrl.hashCode ^
      modelPath.hashCode;
}
