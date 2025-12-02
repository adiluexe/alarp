import 'package:flutter/foundation.dart'; // For immutable annotation
import '../models/challenge.dart';
import '../models/challenge_step.dart';
import '../models/step_result.dart'; // Import the new model

enum ChallengeStatus {
  initial,
  inProgress,
  paused,
  completedSuccess,
  completedFailureTime,
  error, // Added error status
}

@immutable
class ChallengeState {
  final Challenge challenge;
  final ChallengeStatus status;
  final int currentStepIndex;
  final Duration remainingTime;
  final int score;
  final DateTime? stepStartTime; // Added: Track start time of the current step
  final bool?
  wasLastAnswerCorrect; // Added: Track correctness of the last answer
  // Store selected answers for each step type
  final int? selectedPositioningIndex;
  final int? selectedIRSizeIndex; // New
  final int? selectedIROrientationIndex; // New
  final int? selectedPatientPositionIndex; // New
  // Collimation state is handled separately via collimationStateProvider
  final List<StepResult>
  stepResults; // Added: List to store results of each step
  final int currentStreak; // Added: Track current streak of correct answers
  final int bestStreak; // Added: Track best streak in this session
  final String? errorMessage; // Added error message field

  const ChallengeState({
    required this.challenge,
    this.status = ChallengeStatus.initial,
    this.currentStepIndex = 0,
    required this.remainingTime,
    this.score = 0,
    this.stepStartTime,
    this.wasLastAnswerCorrect,
    this.selectedPositioningIndex,
    this.selectedIRSizeIndex,
    this.selectedIROrientationIndex,
    this.selectedPatientPositionIndex,
    this.stepResults = const [],
    this.errorMessage,
    this.currentStreak = 0, // Initialize streak
    this.bestStreak = 0, // Initialize best streak
  });

  // Helper to get the current step object
  ChallengeStep? get currentStep {
    if (currentStepIndex >= 0 && currentStepIndex < challenge.steps.length) {
      return challenge.steps[currentStepIndex];
    }
    return null;
  }

  ChallengeState copyWith({
    ChallengeStatus? status,
    int? currentStepIndex,
    Duration? remainingTime,
    int? score,
    DateTime? stepStartTime,
    bool? wasLastAnswerCorrect,
    int? selectedPositioningIndex,
    int? selectedIRSizeIndex,
    int? selectedIROrientationIndex,
    int? selectedPatientPositionIndex,
    List<StepResult>? stepResults,
    String? errorMessage,
    bool resetSelections = false,
    bool clearLastAnswerStatus = false,
    bool clearErrorMessage = false,
    int? currentStreak, // Added
    int? bestStreak, // Added
  }) {
    return ChallengeState(
      challenge: challenge,
      status: status ?? this.status,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      remainingTime: remainingTime ?? this.remainingTime,
      score: score ?? this.score,
      stepStartTime: stepStartTime ?? this.stepStartTime,
      wasLastAnswerCorrect:
          clearLastAnswerStatus
              ? null
              : (wasLastAnswerCorrect ?? this.wasLastAnswerCorrect),
      selectedPositioningIndex:
          resetSelections
              ? null
              : (selectedPositioningIndex ?? this.selectedPositioningIndex),
      selectedIRSizeIndex:
          resetSelections
              ? null
              : (selectedIRSizeIndex ?? this.selectedIRSizeIndex),
      selectedIROrientationIndex:
          resetSelections
              ? null
              : (selectedIROrientationIndex ?? this.selectedIROrientationIndex),
      selectedPatientPositionIndex:
          resetSelections
              ? null
              : (selectedPatientPositionIndex ??
                  this.selectedPatientPositionIndex),
      stepResults: stepResults ?? this.stepResults,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      currentStreak: currentStreak ?? this.currentStreak, // Added
      bestStreak: bestStreak ?? this.bestStreak, // Added
    );
  }
}
