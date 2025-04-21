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
  final String? errorMessage; // Added error message field

  const ChallengeState({
    required this.challenge,
    this.status = ChallengeStatus.initial,
    this.currentStepIndex = 0,
    required this.remainingTime,
    this.score = 0,
    this.stepStartTime, // Added
    this.wasLastAnswerCorrect, // Added
    this.selectedPositioningIndex,
    this.selectedIRSizeIndex, // New
    this.selectedIROrientationIndex, // New
    this.selectedPatientPositionIndex, // New
    this.stepResults = const [], // Added: Initialize as empty list
    this.errorMessage, // Added
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
    DateTime? stepStartTime, // Added
    bool? wasLastAnswerCorrect, // Added
    int? selectedPositioningIndex,
    int? selectedIRSizeIndex, // New
    int? selectedIROrientationIndex, // New
    int? selectedPatientPositionIndex, // New
    List<StepResult>? stepResults, // Added
    String? errorMessage, // Added
    bool resetSelections = false, // Helper to clear selections on step change
    bool clearLastAnswerStatus =
        false, // Helper to explicitly clear wasLastAnswerCorrect
    bool clearErrorMessage = false, // Helper to clear error message
  }) {
    return ChallengeState(
      challenge: challenge,
      status: status ?? this.status,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      remainingTime: remainingTime ?? this.remainingTime,
      score: score ?? this.score,
      stepStartTime: stepStartTime ?? this.stepStartTime, // Added
      // Handle resetting/updating wasLastAnswerCorrect
      wasLastAnswerCorrect:
          clearLastAnswerStatus
              ? null
              : (wasLastAnswerCorrect ?? this.wasLastAnswerCorrect),
      // Reset specific selections if moving to a new step or explicitly requested
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
      stepResults: stepResults ?? this.stepResults, // Added
      // Handle error message update/clearing
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
