import 'dart:async';
import 'dart:math'; // Added for max()
import 'package:flutter/material.dart'; // Added for WidgetsBinding
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/challenge.dart';
import '../models/challenge_step.dart';
import '../state/challenge_state.dart';
import '../../practice/models/collimation_state.dart';
import '../models/projection.dart'; // Added correct import

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
      stepStartTime:
          DateTime.now(), // Added missing stepStartTime initialization
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

  int _calculateScore(
    ChallengeStep step,
    bool isCorrect,
    Duration timeTaken, {
    double? collimationAccuracy, // Optional for collimation steps
  }) {
    int timeScore = 0;
    int correctnessScore = 0;

    if (step is CollimationStep) {
      // Collimation Time Scoring
      if (timeTaken.inSeconds <= 30) {
        timeScore = 500;
      } else if (timeTaken.inSeconds <= 59) {
        timeScore = 300;
      } else {
        timeScore = 100;
      }
      // Collimation Correctness/Accuracy Scoring
      if (isCorrect && collimationAccuracy != null) {
        if (collimationAccuracy >= 98.0) {
          correctnessScore = 500;
        } else if (collimationAccuracy >= 92.0) {
          correctnessScore = 250;
        } else if (collimationAccuracy >= 86.0) {
          correctnessScore = 200;
        } else {
          correctnessScore = 150;
        }
      } else {
        if (collimationAccuracy != null) {
          if (collimationAccuracy >= 92.0) {
            correctnessScore = 250;
          } else if (collimationAccuracy >= 86.0) {
            correctnessScore = 200;
          } else {
            correctnessScore = 150;
          }
        } else {
          correctnessScore = 150;
        }
      }
    } else {
      if (timeTaken.inSeconds <= 5) {
        timeScore = isCorrect ? 500 : 150;
      } else if (timeTaken.inSeconds <= 10) {
        timeScore = isCorrect ? 300 : 100;
      } else {
        timeScore = isCorrect ? 100 : 50;
      }
      correctnessScore = isCorrect ? 500 : 0;
    }

    return timeScore + correctnessScore;
  }

  double _calculateCollimationAccuracy(
    CollimationStateData currentState,
    CollimationStateData targetState,
  ) {
    const double widthTolerance = 0.05;
    const double heightTolerance = 0.05;
    const double centerTolerance = 0.1;
    const double angleTolerance = 5.0;

    final widthError = ((currentState.width - targetState.width).abs() /
            widthTolerance)
        .clamp(0.0, 1.0);
    final heightError = ((currentState.height - targetState.height).abs() /
            heightTolerance)
        .clamp(0.0, 1.0);
    final centerXError = ((currentState.centerX - targetState.centerX).abs() /
            centerTolerance)
        .clamp(0.0, 1.0);
    final centerYError = ((currentState.centerY - targetState.centerY).abs() /
            centerTolerance)
        .clamp(0.0, 1.0);
    final angleError = ((currentState.angle - targetState.angle).abs() /
            angleTolerance)
        .clamp(0.0, 1.0);

    final averageError =
        (widthError + heightError + centerXError + centerYError + angleError) /
        5.0;

    final accuracy = max(0.0, 100.0 * (1.0 - averageError));
    return accuracy;
  }

  void _handleAnswerSelection<T extends ChallengeStep>(
    int index,
    int? currentStateIndex,
    int Function(T) getCorrectIndex,
    ChallengeState Function(int) copyWithIndex,
  ) {
    if (state.status != ChallengeStatus.inProgress || state.currentStep is! T) {
      return;
    }

    if (currentStateIndex != null) return;

    final step = state.currentStep as T;
    final correctIndex = getCorrectIndex(step);
    final isCorrect = index == correctIndex;

    // Use a null-aware check for stepStartTime as a safety measure
    final startTime = state.stepStartTime ?? DateTime.now();
    final timeTaken = DateTime.now().difference(startTime);
    final scoreDelta = _calculateScore(step, isCorrect, timeTaken);

    // Update state immediately to show selection
    state = copyWithIndex(index);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      if (state.currentStep == step) {
        _advanceStep(scoreDelta: scoreDelta);
      }
    });
  }

  void selectPositioningAnswer(int index) {
    _handleAnswerSelection<PositioningSelectionStep>(
      index,
      state.selectedPositioningIndex,
      (step) => step.correctAnswerIndex,
      (idx) =>
          state.copyWith(selectedPositioningIndex: idx, resetSelections: false),
    );
  }

  void selectIRSizeAnswer(int index) {
    _handleAnswerSelection<IRSizeQuizStep>(
      index,
      state.selectedIRSizeIndex,
      (step) => step.correctAnswerIndex,
      (idx) => state.copyWith(selectedIRSizeIndex: idx, resetSelections: false),
    );
  }

  void selectIROrientationAnswer(int index) {
    _handleAnswerSelection<IROrientationQuizStep>(
      index,
      state.selectedIROrientationIndex,
      (step) => step.correctAnswerIndex,
      (idx) => state.copyWith(
        selectedIROrientationIndex: idx,
        resetSelections: false,
      ),
    );
  }

  void selectPatientPositionAnswer(int index) {
    _handleAnswerSelection<PatientPositionQuizStep>(
      index,
      state.selectedPatientPositionIndex,
      (step) => step.correctAnswerIndex,
      (idx) => state.copyWith(
        selectedPatientPositionIndex: idx,
        resetSelections: false,
      ),
    );
  }

  void submitCollimation() {
    if (state.status != ChallengeStatus.inProgress ||
        state.currentStep is! CollimationStep) {
      return;
    }

    final step = state.currentStep as CollimationStep;
    final stepStartTime = state.stepStartTime ?? DateTime.now();
    final timeTaken = DateTime.now().difference(stepStartTime);

    final currentCollimationState = ref.read(collimationStateProvider);
    final params = (
      bodyPartId: step.bodyPartId,
      projectionName: step.projectionName,
    );
    final projectionData = ref.read(projectionProvider(params));

    double accuracy = 0.0;
    bool isCorrect = false;

    if (projectionData != null && projectionData.targetCollimation != null) {
      accuracy = _calculateCollimationAccuracy(
        currentCollimationState,
        projectionData.targetCollimation!,
      );
      isCorrect = accuracy >= 98.0;
    } else {
      isCorrect = false;
      accuracy = 0.0;
    }

    final scoreDelta = _calculateScore(
      step,
      isCorrect,
      timeTaken,
      collimationAccuracy: accuracy,
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      if (state.currentStep == step) {
        _advanceStep(scoreDelta: scoreDelta);
      }
    });
  }

  void _advanceStep({required int scoreDelta}) {
    if (state.status != ChallengeStatus.inProgress) return;
    if (!mounted) return;

    int updatedScore = state.score + scoreDelta;
    int nextStepIndex = state.currentStepIndex + 1;

    if (nextStepIndex >= state.challenge.steps.length) {
      _timer?.cancel();
      state = state.copyWith(
        status: ChallengeStatus.completedSuccess,
        score: updatedScore,
        currentStepIndex: state.currentStepIndex,
        stepStartTime: null,
        selectedPositioningIndex: null,
        selectedIRSizeIndex: null,
        selectedIROrientationIndex: null,
        selectedPatientPositionIndex: null,
        resetSelections: true,
      );
    } else {
      ChallengeState nextState = state.copyWith(
        currentStepIndex: nextStepIndex,
        score: updatedScore,
        stepStartTime: DateTime.now(),
        selectedPositioningIndex: null,
        selectedIRSizeIndex: null,
        selectedIROrientationIndex: null,
        selectedPatientPositionIndex: null,
        resetSelections: true,
      );

      state = nextState;

      if (state.currentStep is CollimationStep) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ref.read(collimationStateProvider.notifier).reset();
          }
        });
      }
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

final projectionProvider =
    Provider.family<Projection?, ({String bodyPartId, String projectionName})>((
      ref,
      params,
    ) {
      if (params.bodyPartId == 'forearm' && params.projectionName == 'AP') {
        return Projection(
          name: 'AP',
          imageUrl: 'assets/images/practice/forearm/forearm_ap.webp',
          targetCollimation: const CollimationStateData(
            width: 0.6,
            height: 0.9,
            centerX: 0.5,
            centerY: 0.5,
            angle: 0,
          ),
        );
      }
      return null;
    });
