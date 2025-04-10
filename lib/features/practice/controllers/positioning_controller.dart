import 'package:flutter/material.dart';
import '../models/positioning_state.dart';
import '../models/collimation_state.dart';

class PositioningController with ChangeNotifier {
  final PositioningState positioningState;
  final CollimationState collimationState;

  // Target values for correct positioning
  final double targetRotationX;
  final double targetRotationY;
  final double targetRotationZ;
  final double targetWidth;
  final double targetHeight;

  // Acceptable margin of error
  final double positioningTolerance = 5.0; // degrees
  final double collimationTolerance = 0.05; // percentage points

  PositioningController({
    required this.positioningState,
    required this.collimationState,
    this.targetRotationX = 0,
    this.targetRotationY = 0,
    this.targetRotationZ = 0,
    this.targetWidth = 0.6,
    this.targetHeight = 0.6,
  }) {
    // Add listeners to update when the underlying states change
    positioningState.addListener(notifyListeners);
    collimationState.addListener(notifyListeners);
  }

  @override
  void dispose() {
    // Remove listeners to avoid memory leaks
    positioningState.removeListener(notifyListeners);
    collimationState.removeListener(notifyListeners);
    super.dispose();
  }

  // All other methods remain the same
  // Check if positioning is correct
  bool get isPositioningCorrect {
    return (positioningState.rotationX - targetRotationX).abs() <=
            positioningTolerance &&
        (positioningState.rotationY - targetRotationY).abs() <=
            positioningTolerance &&
        (positioningState.rotationZ - targetRotationZ).abs() <=
            positioningTolerance;
  }

  // Check if collimation is correct
  bool get isCollimationCorrect {
    return (collimationState.width - targetWidth).abs() <=
            collimationTolerance &&
        (collimationState.height - targetHeight).abs() <= collimationTolerance;
  }

  // Overall correctness
  bool get isCorrect => isPositioningCorrect && isCollimationCorrect;

  // Calculate positioning accuracy percentage
  double get positioningAccuracy {
    double xDiff =
        1.0 - ((positioningState.rotationX - targetRotationX).abs() / 180);
    double yDiff =
        1.0 - ((positioningState.rotationY - targetRotationY).abs() / 180);
    double zDiff =
        1.0 - ((positioningState.rotationZ - targetRotationZ).abs() / 180);

    return (xDiff + yDiff + zDiff) / 3 * 100;
  }

  // Calculate collimation accuracy percentage
  double get collimationAccuracy {
    double widthDiff = 1.0 - ((collimationState.width - targetWidth).abs());
    double heightDiff = 1.0 - ((collimationState.height - targetHeight).abs());

    return (widthDiff + heightDiff) / 2 * 100;
  }

  // Overall accuracy
  double get overallAccuracy {
    return (positioningAccuracy + collimationAccuracy) / 2;
  }
}
