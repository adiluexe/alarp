import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/collimation_state.dart';
import '../data/collimation_target_data.dart'; // Import the new file

// Define a type for the provider family parameter
typedef CollimationParams = ({String bodyPartId, String projectionName});

class CollimationController {
  final Ref ref;
  // Store both bodyPartId and projectionName
  final String bodyPartId;
  final String projectionName;

  // Target values specific to this instance/projection
  late final Map<String, double> _targets;

  CollimationController(this.ref, CollimationParams params)
    : bodyPartId = params.bodyPartId,
      projectionName = params.projectionName {
    // Get targets using the imported function
    _targets = getTargetCollimationValues(bodyPartId, projectionName);
  }

  CollimationStateData get _collimationState =>
      ref.read(collimationStateProvider);

  // Calculate collimation accuracy using instance-specific targets
  double get collimationAccuracy {
    final targetWidth = _targets['width']!;
    final targetHeight = _targets['height']!;
    final targetCenterX = _targets['centerX']!;
    final targetCenterY = _targets['centerY']!;
    final targetAngle = _targets['angle']!;

    final widthDiff = (_collimationState.width - targetWidth).abs();
    final heightDiff = (_collimationState.height - targetHeight).abs();
    final centerXDiff = (_collimationState.centerX - targetCenterX).abs();
    final centerYDiff = (_collimationState.centerY - targetCenterY).abs();
    final angleDiff = (_collimationState.angle - targetAngle).abs();

    final totalDiff =
        widthDiff + heightDiff + centerXDiff + centerYDiff + angleDiff;

    final maxDiff =
        (1.0 - 0.1) + // width range
        (1.0 - 0.1) + // height range
        (1.0 - (-1.0)) + // centerX range
        (1.0 - (-1.0)) + // centerY range
        (45.0 - (-45.0)); // angle range

    final accuracy = max(0.0, 100.0 * (1.0 - (totalDiff / maxDiff)));
    return accuracy;
  }

  double get overallAccuracy {
    return collimationAccuracy;
  }

  bool get isCorrect {
    return overallAccuracy >= 98.0;
  }
}

// Update provider to a family provider accepting the CollimationParams record
final collimationControllerProvider =
    Provider.family<CollimationController, CollimationParams>((ref, params) {
      return CollimationController(ref, params);
    });
