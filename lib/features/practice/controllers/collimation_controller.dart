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

    // Define tolerances for each parameter (adjust these for desired strictness)
    const double widthTolerance = 0.05; // e.g., +/- 5% of the total range (0.9)
    const double heightTolerance = 0.05;
    const double centerTolerance = 0.1; // e.g., +/- 5% of the total range (2.0)
    const double angleTolerance = 5.0; // e.g., +/- 5 degrees

    // Calculate normalized error for each parameter (clamped between 0 and 1)
    final widthError = ((_collimationState.width - targetWidth).abs() /
            widthTolerance)
        .clamp(0.0, 1.0);
    final heightError = ((_collimationState.height - targetHeight).abs() /
            heightTolerance)
        .clamp(0.0, 1.0);
    final centerXError = ((_collimationState.centerX - targetCenterX).abs() /
            centerTolerance)
        .clamp(0.0, 1.0);
    final centerYError = ((_collimationState.centerY - targetCenterY).abs() /
            centerTolerance)
        .clamp(0.0, 1.0);
    final angleError = ((_collimationState.angle - targetAngle).abs() /
            angleTolerance)
        .clamp(0.0, 1.0);

    // Calculate the average error
    final averageError =
        (widthError + heightError + centerXError + centerYError + angleError) /
        5.0;

    // Accuracy is 100% minus the average error percentage
    final accuracy = max(0.0, 100.0 * (1.0 - averageError));
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
