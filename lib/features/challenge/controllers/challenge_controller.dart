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
          status: ChallengeStatus.initial,
          currentStepIndex: -1,
          remainingTime: initialChallenge.timeLimit,
        ),
      );

  void resetChallenge() {
    _timer?.cancel();
    ref.read(collimationStateProvider.notifier).reset();
    state = ChallengeState(
      challenge: initialChallenge,
      status: ChallengeStatus.initial,
      currentStepIndex: -1,
      remainingTime: initialChallenge.timeLimit,
      selectedPositioningIndex: null,
      selectedIRSizeIndex: null,
      selectedIROrientationIndex: null,
      selectedPatientPositionIndex: null,
      score: 0,
    );
  }

  void startChallenge() {
    if (state.status != ChallengeStatus.initial) {
      resetChallenge();
    }

    state = state.copyWith(
      status: ChallengeStatus.inProgress,
      currentStepIndex: 0,
      remainingTime: state.challenge.timeLimit,
      score: 0,
      selectedPositioningIndex: null,
      selectedIRSizeIndex: null,
      selectedIROrientationIndex: null,
      selectedPatientPositionIndex: null,
      resetSelections: true,
    );
    _startTimer();

    if (state.currentStep is CollimationStep) {
      ref.read(collimationStateProvider.notifier).reset();
    }
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

    if (state.selectedPositioningIndex != null) return;

    final step = state.currentStep as PositioningSelectionStep;
    state = state.copyWith(
      selectedPositioningIndex: index,
      resetSelections: false,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (index == step.correctAnswerIndex) {
        _advanceStep(correct: true);
      } else {
        _failChallenge(ChallengeStatus.completedFailureIncorrect);
      }
    });
  }

  void selectIRSizeAnswer(int index) {
    if (state.status != ChallengeStatus.inProgress ||
        state.currentStep is! IRSizeQuizStep) {
      return;
    }

    if (state.selectedIRSizeIndex != null) return;

    final step = state.currentStep as IRSizeQuizStep;
    state = state.copyWith(selectedIRSizeIndex: index, resetSelections: false);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (index == step.correctAnswerIndex) {
        _advanceStep(correct: true);
      } else {
        _failChallenge(ChallengeStatus.completedFailureIncorrect);
      }
    });
  }

  void selectIROrientationAnswer(int index) {
    if (state.status != ChallengeStatus.inProgress ||
        state.currentStep is! IROrientationQuizStep) {
      return;
    }

    if (state.selectedIROrientationIndex != null) return;

    final step = state.currentStep as IROrientationQuizStep;
    state = state.copyWith(
      selectedIROrientationIndex: index,
      resetSelections: false,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (index == step.correctAnswerIndex) {
        _advanceStep(correct: true);
      } else {
        _failChallenge(ChallengeStatus.completedFailureIncorrect);
      }
    });
  }

  void selectPatientPositionAnswer(int index) {
    if (state.status != ChallengeStatus.inProgress ||
        state.currentStep is! PatientPositionQuizStep) {
      return;
    }

    if (state.selectedPatientPositionIndex != null) return;

    final step = state.currentStep as PatientPositionQuizStep;
    state = state.copyWith(
      selectedPatientPositionIndex: index,
      resetSelections: false,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (index == step.correctAnswerIndex) {
        _advanceStep(correct: true);
      } else {
        _failChallenge(ChallengeStatus.completedFailureIncorrect);
      }
    });
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

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      if (collimationController.isCorrect) {
        _advanceStep(correct: true);
      } else {
        _failChallenge(ChallengeStatus.completedFailureIncorrect);
      }
    });
  }

  void _advanceStep({required bool correct}) {
    if (state.status != ChallengeStatus.inProgress) return;
    if (!mounted) return;

    int updatedScore = state.score + (correct ? 1 : 0);
    int nextStepIndex = state.currentStepIndex + 1;

    print(
      'Advancing Step: Current Index=${state.currentStepIndex}, Next Index=$nextStepIndex, Steps Total=${state.challenge.steps.length}',
    );

    if (nextStepIndex >= state.challenge.steps.length) {
      print('Advancing Step: Reached end of challenge.');
      _timer?.cancel();
      state = state.copyWith(
        status: ChallengeStatus.completedSuccess,
        score: updatedScore,
        currentStepIndex: state.currentStepIndex,
        selectedPositioningIndex: null,
        selectedIRSizeIndex: null,
        selectedIROrientationIndex: null,
        selectedPatientPositionIndex: null,
        resetSelections: true,
      );
    } else {
      print('Advancing Step: Moving to step index $nextStepIndex.');
      ChallengeState nextState = state.copyWith(
        currentStepIndex: nextStepIndex,
        score: updatedScore,
        selectedPositioningIndex: null,
        selectedIRSizeIndex: null,
        selectedIROrientationIndex: null,
        selectedPatientPositionIndex: null,
        resetSelections: true,
      );

      state = nextState;

      if (state.currentStep is CollimationStep) {
        print(
          'Advancing Step: Next step is Collimation, resetting collimation state.',
        );
        ref.read(collimationStateProvider.notifier).reset();
      } else {
        print(
          'Advancing Step: Next step is ${state.currentStep?.runtimeType}, not resetting collimation.',
        );
      }
    }
  }

  void _failChallenge(ChallengeStatus failureStatus) {
    if (state.status != ChallengeStatus.inProgress) return;
    if (!mounted) return;
    _timer?.cancel();
    state = state.copyWith(
      status: failureStatus,
      selectedPositioningIndex: null,
      selectedIRSizeIndex: null,
      selectedIROrientationIndex: null,
      selectedPatientPositionIndex: null,
      resetSelections: true,
    );
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
