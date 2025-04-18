import 'package:flutter/foundation.dart'; // For immutable annotation
import '../models/challenge.dart';
import '../models/challenge_step.dart';

enum ChallengeStatus {
  initial,
  inProgress,
  paused,
  completedSuccess,
  completedFailureTime,
  completedFailureIncorrect,
}

@immutable
class ChallengeState {
  final Challenge challenge;
  final ChallengeStatus status;
  final int currentStepIndex;
  final Duration remainingTime;
  final int score;
  // Store selected answers for each step type
  final int? selectedPositioningIndex;
  final int? selectedIRSizeIndex; // New
  final int? selectedIROrientationIndex; // New
  final int? selectedPatientPositionIndex; // New
  // Collimation state is handled separately via collimationStateProvider

  const ChallengeState({
    required this.challenge,
    this.status = ChallengeStatus.initial,
    this.currentStepIndex = 0,
    required this.remainingTime,
    this.score = 0,
    this.selectedPositioningIndex,
    this.selectedIRSizeIndex, // New
    this.selectedIROrientationIndex, // New
    this.selectedPatientPositionIndex, // New
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
    int? selectedPositioningIndex,
    int? selectedIRSizeIndex, // New
    int? selectedIROrientationIndex, // New
    int? selectedPatientPositionIndex, // New
    bool resetSelections = false, // Helper to clear selections on step change
  }) {
    return ChallengeState(
      challenge: challenge,
      status: status ?? this.status,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      remainingTime: remainingTime ?? this.remainingTime,
      score: score ?? this.score,
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
    );
  }
}
