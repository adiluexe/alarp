import 'package:flutter/foundation.dart'; // Keep this for Flutter's ValueGetter
import '../models/challenge.dart';
import '../models/challenge_step.dart';

enum ChallengeStatus {
  notStarted,
  inProgress,
  paused, // Optional
  completedSuccess,
  completedFailureTime,
  completedFailureIncorrect,
}

class ChallengeState {
  final Challenge challenge;
  final ChallengeStatus status;
  final int currentStepIndex;
  final Duration remainingTime;
  final int? selectedPositioningIndex; // User's selection in positioning step
  // Add score, accuracy etc. later

  const ChallengeState({
    required this.challenge,
    required this.status,
    required this.currentStepIndex,
    required this.remainingTime,
    this.selectedPositioningIndex,
  });

  // Helper getter for the current step object
  ChallengeStep? get currentStep {
    if (currentStepIndex >= 0 && currentStepIndex < challenge.steps.length) {
      return challenge.steps[currentStepIndex];
    }
    return null;
  }

  // Manually add copyWith
  ChallengeState copyWith({
    Challenge? challenge,
    ChallengeStatus? status,
    int? currentStepIndex,
    Duration? remainingTime,
    // Change type to a nullable function returning nullable int
    int? Function()? selectedPositioningIndex,
  }) {
    return ChallengeState(
      challenge: challenge ?? this.challenge,
      status: status ?? this.status,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      remainingTime: remainingTime ?? this.remainingTime,
      // If the function is provided, call it to get the new value
      selectedPositioningIndex:
          selectedPositioningIndex != null
              ? selectedPositioningIndex()
              : this.selectedPositioningIndex,
    );
  }
}
