import 'package:flutter/foundation.dart';

/// Represents a single practice attempt recorded by the user.
@immutable
class PracticeAttempt {
  final String id;
  final String userId;
  final String bodyPartId;
  final String projectionName;
  final double accuracy;
  final DateTime createdAt;

  const PracticeAttempt({
    required this.id,
    required this.userId,
    required this.bodyPartId,
    required this.projectionName,
    required this.accuracy,
    required this.createdAt,
  });

  /// Creates a PracticeAttempt instance from a JSON map (typically from Supabase).
  factory PracticeAttempt.fromJson(Map<String, dynamic> json) {
    // Basic validation
    if (json['id'] == null ||
        json['user_id'] == null ||
        json['body_part_id'] == null ||
        json['projection_name'] == null ||
        json['accuracy'] == null ||
        json['created_at'] == null) {
      throw FormatException(
        "Missing required fields in PracticeAttempt JSON: $json",
      );
    }

    return PracticeAttempt(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bodyPartId: json['body_part_id'] as String,
      projectionName: json['projection_name'] as String,
      // Ensure accuracy is parsed correctly, defaulting or throwing if invalid
      accuracy: (json['accuracy'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Converts a PracticeAttempt instance to a JSON map (for potential future use, e.g., sending data).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'body_part_id': bodyPartId,
      'projection_name': projectionName,
      'accuracy': accuracy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Optional: Implement equality and hashCode for comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PracticeAttempt &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          bodyPartId == other.bodyPartId &&
          projectionName == other.projectionName &&
          accuracy == other.accuracy &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      bodyPartId.hashCode ^
      projectionName.hashCode ^
      accuracy.hashCode ^
      createdAt.hashCode;

  // Optional: Implement toString for debugging
  @override
  String toString() {
    return 'PracticeAttempt{id: $id, userId: $userId, bodyPartId: $bodyPartId, projectionName: $projectionName, accuracy: $accuracy, createdAt: $createdAt}';
  }
}
