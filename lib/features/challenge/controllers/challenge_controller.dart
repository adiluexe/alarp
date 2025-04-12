import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/challenge.dart';
import '../models/challenge_step.dart';
import '../state/challenge_state.dart';
// Import collimation state/controller if needed for checking collimation step
import '../../practice/models/collimation_state.dart';
import '../../practice/controllers/collimation_controller.dart';

class ChallengeController extends StateNotifier<ChallengeState> {
  final Ref ref;
  Timer? _timer;

  ChallengeController(this.ref, Challenge challenge)
    : super(
        ChallengeState(
          challenge: challenge,
          status: ChallengeStatus.notStarted,
          currentStepIndex: -1, // Start before the first step
          remainingTime: challenge.timeLimit,
        ),
      );

  void startChallenge() {
    if (state.status != ChallengeStatus.notStarted) {
      return;
    }

    // Reset collimation state if reusing the provider
    ref.read(collimationStateProvider.notifier).reset();

    state = state.copyWith(
      status: ChallengeStatus.inProgress,
      currentStepIndex: 0, // Move to the first step
      remainingTime: state.challenge.timeLimit,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime.inSeconds <= 0) {
        timer.cancel();
        state = state.copyWith(status: ChallengeStatus.completedFailureTime);
      } else {
        state = state.copyWith(
          remainingTime: state.remainingTime - const Duration(seconds: 1),
        );
      }
    });
  }

  void selectPositioningAnswer(int index) {
    if (state.status != ChallengeStatus.inProgress ||
        state.currentStep is! PositioningSelectionStep) {
      return;
    }

    final step = state.currentStep as PositioningSelectionStep;
    state = state.copyWith(
      // Pass the function directly
      selectedPositioningIndex: () => index,
    ); // Record selection

    if (index == step.correctImageIndex) {
      // Correct - move to next step or complete
      _moveToNextStep();
    } else {
      // Incorrect - fail challenge
      _timer?.cancel();
      state = state.copyWith(status: ChallengeStatus.completedFailureIncorrect);
    }
  }

  void submitCollimation() {
    if (state.status != ChallengeStatus.inProgress ||
        state.currentStep is! CollimationStep) {
      return;
    }

    final step = state.currentStep as CollimationStep;
    // Use the CollimationController (specific to this projection) to check accuracy
    final collimationController = ref.read(
      collimationControllerProvider(step.projectionName),
    );

    // Define success criteria (e.g., >= 90% accuracy)
    if (collimationController.isCorrect) {
      _moveToNextStep(); // Move to next step or complete
    } else {
      // Incorrect collimation - fail challenge
      _timer?.cancel();
      state = state.copyWith(status: ChallengeStatus.completedFailureIncorrect);
    }
  }

  void _moveToNextStep() {
    if (state.currentStepIndex + 1 < state.challenge.steps.length) {
      state = state.copyWith(
        currentStepIndex: state.currentStepIndex + 1,
        // Pass the function directly
        selectedPositioningIndex: () => null,
      );
      // Reset collimation if the next step is collimation (or handle differently)
      if (state.currentStep is CollimationStep) {
        ref.read(collimationStateProvider.notifier).reset();
      }
    } else {
      // All steps completed successfully
      _timer?.cancel();
      state = state.copyWith(status: ChallengeStatus.completedSuccess);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Provider for the ChallengeController
// Using .family because each active challenge needs its own controller instance
final challengeControllerProvider = StateNotifierProvider.family<
  ChallengeController,
  ChallengeState,
  Challenge
>((ref, challenge) {
  return ChallengeController(ref, challenge);
});
