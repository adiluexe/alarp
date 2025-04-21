import 'package:flutter/foundation.dart';

/// Represents the outcome of a single step within a challenge.
@immutable
class StepResult {
  final String stepId;
  final bool isCorrect;
  final int scoreEarned;
  final String? stepInstruction; // Optional: To display which step it was
  final double? accuracy; // Optional: For collimation steps
  // Add other relevant fields like userAnswer, correctAnswer if needed for breakdown

  const StepResult({
    required this.stepId,
    required this.isCorrect,
    required this.scoreEarned,
    this.stepInstruction,
    this.accuracy,
  });

  // Factory constructor to create StepResult from JSON
  factory StepResult.fromJson(Map<String, dynamic> json) {
    return StepResult(
      stepId: json['step_id'] as String,
      isCorrect: json['is_correct'] as bool,
      scoreEarned: json['score_earned'] as int,
      stepInstruction: json['step_instruction'] as String?,
      accuracy:
          (json['accuracy'] as num?)?.toDouble(), // Handle potential num type
    );
  }

  // Method to convert StepResult to JSON
  Map<String, dynamic> toJson() {
    return {
      'step_id': stepId,
      'is_correct': isCorrect,
      'score_earned': scoreEarned,
      'step_instruction': stepInstruction,
      'accuracy': accuracy,
    };
  }

  // Optional: Add copyWith or other helper methods if needed later
}
