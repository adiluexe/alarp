import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/challenge.dart';
import '../models/challenge_step.dart';
import '../state/challenge_state.dart';
import '../../practice/models/collimation_state.dart';
import '../../practice/controllers/collimation_controller.dart';

class ChallengeController extends StateNotifier<ChallengeState> {
  final Ref ref;
  Timer? _timer;
  final Challenge initialChallenge;

  ChallengeController(this.ref, this.initialChallenge)
    : super(
        ChallengeState(
          challenge: initialChallenge,
          status: ChallengeStatus.notStarted,
          currentStepIndex: -1,
          remainingTime: initialChallenge.timeLimit,
        ),
      );

  void resetChallenge() {
    _timer?.cancel();
    ref.read(collimationStateProvider.notifier).reset();
    state = ChallengeState(
      challenge: initialChallenge,
      status: ChallengeStatus.notStarted,
      currentStepIndex: -1,
      remainingTime: initialChallenge.timeLimit,
      selectedPositioningIndex: null,
    );
    print("Challenge state reset.");
  }

  void startChallenge() {
    if (state.status != ChallengeStatus.notStarted) {
      print(
        "Challenge cannot start, status is ${state.status}. Call resetChallenge() first.",
      );
      return;
    }

    ref.read(collimationStateProvider.notifier).reset();

    state = state.copyWith(
      status: ChallengeStatus.inProgress,
      currentStepIndex: 0,
      remainingTime: state.challenge.timeLimit,
    );
    _startTimer();
    print("Challenge started.");
  }

  void _startTimer() {
    _timer?.cancel();
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
    state = state.copyWith(selectedPositioningIndex: () => index);

    if (index == step.correctImageIndex) {
      _moveToNextStep();
    } else {
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
    final params = (
      bodyPartId: step.bodyPartId,
      projectionName: step.projectionName,
    );
    final collimationController = ref.read(
      collimationControllerProvider(params),
    );

    if (collimationController.isCorrect) {
      _moveToNextStep();
    } else {
      _timer?.cancel();
      state = state.copyWith(status: ChallengeStatus.completedFailureIncorrect);
    }
  }

  void _moveToNextStep() {
    if (state.currentStepIndex + 1 < state.challenge.steps.length) {
      state = state.copyWith(
        currentStepIndex: state.currentStepIndex + 1,
        selectedPositioningIndex: () => null,
      );
      if (state.currentStep is CollimationStep) {
        ref.read(collimationStateProvider.notifier).reset();
      }
    } else {
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

final challengeControllerProvider = StateNotifierProvider.family<
  ChallengeController,
  ChallengeState,
  Challenge
>((ref, challenge) {
  return ChallengeController(ref, challenge);
});
