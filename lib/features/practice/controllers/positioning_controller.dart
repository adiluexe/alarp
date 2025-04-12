import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/positioning_state.dart';
import '../models/collimation_state.dart';

// Define target values (replace with actual logic later)
const _targetRotationX = 10.0;
const _targetRotationY = 0.0;
const _targetRotationZ = 0.0;
const _targetCollimationWidth = 0.6;
const _targetCollimationHeight = 0.7;
const _targetCollimationCenterX = 0.1;
const _targetCollimationCenterY = -0.1;

class PositioningController {
  final Ref ref;

  PositioningController(this.ref);

  // Read the current state from providers
  PositioningStateData get _positioningState =>
      ref.read(positioningStateProvider);
  CollimationStateData get _collimationState =>
      ref.read(collimationStateProvider);

  // Calculate positioning accuracy
  double get positioningAccuracy {
    final rotXDiff = (_positioningState.rotationX - _targetRotationX).abs();
    final rotYDiff = (_positioningState.rotationY - _targetRotationY).abs();
    final rotZDiff = (_positioningState.rotationZ - _targetRotationZ).abs();

    // Simple average difference, scaled to percentage (lower diff = higher accuracy)
    // Max possible diff per axis is 180. Total max diff = 540.
    final totalDiff = rotXDiff + rotYDiff + rotZDiff;
    final maxDiff = 180.0 * 3; // Max diff for 3 axes
    final accuracy = max(0.0, 100.0 * (1.0 - (totalDiff / maxDiff)));
    return accuracy;
  }

  // Calculate collimation accuracy
  double get collimationAccuracy {
    final widthDiff = (_collimationState.width - _targetCollimationWidth).abs();
    final heightDiff =
        (_collimationState.height - _targetCollimationHeight).abs();
    final centerXDiff =
        (_collimationState.centerX - _targetCollimationCenterX).abs();
    final centerYDiff =
        (_collimationState.centerY - _targetCollimationCenterY).abs();

    // Max diff for width/height is ~1.0, for center is ~2.0. Total max ~6.0
    final totalDiff = widthDiff + heightDiff + centerXDiff + centerYDiff;
    final maxDiff =
        (1.0 - 0.2) +
        (1.0 - 0.2) +
        (1.0 - (-1.0)) +
        (1.0 - (-1.0)); // Approx max diff
    final accuracy = max(0.0, 100.0 * (1.0 - (totalDiff / maxDiff)));
    return accuracy;
  }

  // Calculate overall accuracy
  double get overallAccuracy {
    return (positioningAccuracy + collimationAccuracy) / 2.0;
  }

  // Check if positioning is considered correct (e.g., > 90% accuracy)
  bool get isCorrect {
    return overallAccuracy >= 90.0;
  }
}

// Provider for the PositioningController
final positioningControllerProvider = Provider<PositioningController>((ref) {
  return PositioningController(ref);
});
