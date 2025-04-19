import 'package:flutter/foundation.dart'; // For immutable annotation

// Base class for all challenge steps
@immutable
abstract class ChallengeStep {
  final String id;
  final String? instruction; // Optional instruction text for the step

  const ChallengeStep({required this.id, this.instruction});
}

// Step 1: Select the correct positioning image
@immutable
class PositioningSelectionStep extends ChallengeStep {
  final String question;
  final List<String> imageAssets; // Paths to positioning images
  final int correctAnswerIndex;

  const PositioningSelectionStep({
    required super.id,
    required this.question,
    required this.imageAssets,
    required this.correctAnswerIndex,
    super.instruction,
  });
}

// Step 2: Select the correct IR Size (New)
@immutable
class IRSizeQuizStep extends ChallengeStep {
  final String question;
  final List<String> options; // e.g., ["8x10", "10x12", "14x17"]
  final int correctAnswerIndex;

  const IRSizeQuizStep({
    required super.id,
    this.question = 'Select the correct IR Size:', // Default question
    required this.options,
    required this.correctAnswerIndex,
    super.instruction,
  });
}

// Step 3: Select the correct IR Orientation (New)
@immutable
class IROrientationQuizStep extends ChallengeStep {
  final String question;
  final List<String> options; // e.g., ["Crosswise", "Lengthwise"]
  final int correctAnswerIndex;

  const IROrientationQuizStep({
    required super.id,
    this.question = 'Select the correct IR Orientation:', // Default question
    required this.options,
    required this.correctAnswerIndex,
    super.instruction,
  });
}

// Step 4: Select the correct Patient Position (New)
@immutable
class PatientPositionQuizStep extends ChallengeStep {
  final String question;
  final List<String> options; // e.g., ["Upright", "Seated", "Supine"]
  final int correctAnswerIndex;

  const PatientPositionQuizStep({
    required super.id,
    this.question = 'Select the correct Patient Position:', // Default question
    required this.options,
    required this.correctAnswerIndex,
    super.instruction,
  });
}

// Step 5: Perform collimation (Existing, now step 5)
@immutable
class CollimationStep extends ChallengeStep {
  final String bodyPartId;
  final String projectionName;
  // Target values are fetched separately using bodyPartId and projectionName

  const CollimationStep({
    required super.id,
    required this.bodyPartId,
    required this.projectionName,
    super.instruction =
        'Adjust the collimation field correctly.', // Default instruction
  });
}
