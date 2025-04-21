import 'dart:async';
import 'dart:math'; // Added for max()
import 'package:flutter/material.dart'; // Added for WidgetsBinding
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/challenge.dart';
import '../models/challenge_step.dart';
import '../state/challenge_state.dart';
import '../../practice/data/collimation_target_data.dart'; // Corrected import path
import '../../practice/models/collimation_state.dart'; // Import CollimationStateData and provider
import '../models/projection.dart'; // Added correct import
import '../models/step_result.dart'; // Import StepResult

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
      wasLastAnswerCorrect: null, // Reset correctness status
      stepResults: [], // Reset step results
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
      wasLastAnswerCorrect: null, // Ensure null at start
      stepResults: [], // Ensure results list is empty at start
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
        if (collimationAccuracy >= 90.0) {
          correctnessScore = 500;
        } else if (collimationAccuracy >= 85.0) {
          correctnessScore = 250;
        } else if (collimationAccuracy >= 80.0) {
          correctnessScore = 200;
        } else {
          correctnessScore = 150;
        }
      } else {
        if (collimationAccuracy != null) {
          if (collimationAccuracy >= 85.0) {
            correctnessScore = 250;
          } else if (collimationAccuracy >= 80.0) {
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

    // Create the result for this step
    final stepResult = StepResult(
      stepId: step.id,
      isCorrect: isCorrect,
      scoreEarned: scoreDelta,
      stepInstruction: step.instruction, // Store instruction for display
    );

    // Update state immediately to show selection AND correctness
    state = copyWithIndex(index).copyWith(wasLastAnswerCorrect: isCorrect);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      if (state.currentStep == step) {
        // Pass the result to _advanceStep
        _advanceStep(scoreDelta: scoreDelta, result: stepResult);
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
      // Define correctness threshold for collimation (e.g., 95% accuracy)
      isCorrect = accuracy >= 95.0;
    } else {
      // Handle case where target data is missing
      isCorrect = false;
      accuracy = 0.0;
    }

    final scoreDelta = _calculateScore(
      step,
      isCorrect,
      timeTaken,
      collimationAccuracy: accuracy,
    );

    // Create the result for this step, including accuracy
    final stepResult = StepResult(
      stepId: step.id,
      isCorrect: isCorrect,
      scoreEarned: scoreDelta,
      stepInstruction: step.instruction,
      accuracy: accuracy, // Store accuracy for collimation
    );

    // Update state to show correctness before advancing
    state = state.copyWith(wasLastAnswerCorrect: isCorrect);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      if (state.currentStep == step) {
        // Pass the result to _advanceStep
        _advanceStep(scoreDelta: scoreDelta, result: stepResult);
      }
    });
  }

  void _advanceStep({required int scoreDelta, required StepResult result}) {
    if (state.status != ChallengeStatus.inProgress) return;
    if (!mounted) return;

    int updatedScore = state.score + scoreDelta;
    int nextStepIndex = state.currentStepIndex + 1;
    // Add the result of the completed step to the list
    List<StepResult> updatedResults = List.from(state.stepResults)..add(result);

    if (nextStepIndex >= state.challenge.steps.length) {
      _timer?.cancel();
      state = state.copyWith(
        status: ChallengeStatus.completedSuccess,
        score: updatedScore,
        currentStepIndex: state.currentStepIndex, // Keep last index for context
        stepStartTime: null,
        stepResults: updatedResults, // Store final results list
        resetSelections: true,
        clearLastAnswerStatus: true,
      );
    } else {
      ChallengeState nextState = state.copyWith(
        currentStepIndex: nextStepIndex,
        score: updatedScore,
        stepStartTime: DateTime.now(),
        stepResults: updatedResults, // Update results list
        resetSelections: true,
        clearLastAnswerStatus: true,
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

final projectionProvider = Provider.family<
  Projection?,
  ({String bodyPartId, String projectionName})
>((ref, params) {
  // --- Get Target Data ---
  final targetValues = getTargetCollimationValues(
    params.bodyPartId,
    params.projectionName,
  );
  final targetInfo = getTargetInfo(params.bodyPartId, params.projectionName);

  // --- Get Image Path ---
  // Standardize names for image path construction
  final standardizedBodyPart = params.bodyPartId.toLowerCase();
  final standardizedProjection = params.projectionName
      .toLowerCase()
      .replaceAll(' ', '_')
      .replaceAll('(', '')
      .replaceAll(')', '');

  final imagePath =
      'assets/images/practice/$standardizedBodyPart/${standardizedBodyPart}_$standardizedProjection.webp';

  // --- Create CollimationStateData from targetValues ---
  final targetCollimationState = CollimationStateData(
    width: targetValues['width'] ?? 0.5,
    height: targetValues['height'] ?? 0.5,
    centerX: targetValues['centerX'] ?? 0.0,
    centerY: targetValues['centerY'] ?? 0.0,
    angle: targetValues['angle'] ?? 0.0,
  );

  // --- Return Projection Object ---
  // Consider adding error handling if imagePath is invalid or target data is missing
  return Projection(
    name: params.projectionName,
    imageUrl: imagePath,
    targetCollimation: targetCollimationState,
    // Add other info if needed
    irSize: targetInfo.irSize,
    irOrientation: targetInfo.irOrientation,
    pxPosition: targetInfo.pxPosition,
  );
});
