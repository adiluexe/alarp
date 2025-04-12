import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/collimation_state.dart';

// Placeholder function to get target values based on projection
// TODO: Replace this with actual data fetching (e.g., from a map, model, or DB)
Map<String, double> _getTargetValues(String projectionName) {
  // Example: Return different targets for different projections
  switch (projectionName.toLowerCase()) {
    case 'ap':
    case 'pa':
      return {'width': 0.7, 'height': 0.8, 'centerX': 0.0, 'centerY': 0.0};
    case 'lateral':
      return {'width': 0.5, 'height': 0.9, 'centerX': 0.1, 'centerY': -0.05};
    case 'oblique':
      return {'width': 0.6, 'height': 0.75, 'centerX': -0.1, 'centerY': 0.1};
    default: // Default/fallback values
      return {'width': 0.6, 'height': 0.7, 'centerX': 0.1, 'centerY': -0.1};
  }
}

class CollimationController {
  final Ref ref;
  final String projectionName; // Store the projection name

  // Target values specific to this instance/projection
  late final Map<String, double> _targets;

  CollimationController(this.ref, this.projectionName) {
    // Get targets when the controller is created
    _targets = _getTargetValues(projectionName);
  }

  CollimationStateData get _collimationState =>
      ref.read(collimationStateProvider);

  // Calculate collimation accuracy using instance-specific targets
  double get collimationAccuracy {
    final targetWidth = _targets['width']!;
    final targetHeight = _targets['height']!;
    final targetCenterX = _targets['centerX']!;
    final targetCenterY = _targets['centerY']!;

    final widthDiff = (_collimationState.width - targetWidth).abs();
    final heightDiff = (_collimationState.height - targetHeight).abs();
    final centerXDiff = (_collimationState.centerX - targetCenterX).abs();
    final centerYDiff = (_collimationState.centerY - targetCenterY).abs();

    final totalDiff = widthDiff + heightDiff + centerXDiff + centerYDiff;

    // Max diff calculation remains the same (based on slider ranges)
    final maxDiff =
        (1.0 - 0.2) + // width range
        (1.0 - 0.2) + // height range
        (1.0 - (-1.0)) + // centerX range
        (1.0 - (-1.0)); // centerY range
    final accuracy = max(0.0, 100.0 * (1.0 - (totalDiff / maxDiff)));
    return accuracy;
  }

  double get overallAccuracy {
    return collimationAccuracy;
  }

  bool get isCorrect {
    return overallAccuracy >= 90.0;
  }
}

// Update provider to a family provider accepting the projection name
final collimationControllerProvider =
    Provider.family<CollimationController, String>((ref, projectionName) {
      return CollimationController(ref, projectionName);
    });
