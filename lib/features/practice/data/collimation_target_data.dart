// Defines the target collimation values for different body part/projection combinations.

// Example target data structure (replace/expand with your actual data)
const Map<String, Map<String, double>> _targetData = {
  'forearm_ap': {
    'width': 0.2,
    'height': 0.6,
    'centerX': -0.1,
    'centerY': 1.0, // Still max edge, double-check if correct
    'angle': 0.0,
  },
  'forearm_lateral': {
    'width': 0.2,
    'height': 0.7,
    'centerX': 0.1,
    'centerY': 1.0,
    'angle': 0.0,
  },
  'elbow_ap': {
    // Example for another part/projection
    'width': 0.4,
    'height': 0.4,
    'centerX': 0.0,
    'centerY': 0.0,
    'angle': 0.0,
  },
  // Add all other bodyPart_projection combinations here...
  // e.g., 'shoulder_ap_internal_rotation': { ... },
};

// Default values if no specific target is found
const Map<String, double> _defaultTargets = {
  'width': 0.5,
  'height': 0.5,
  'centerX': 0.0,
  'centerY': 0.0,
  'angle': 0.0,
};

/// Retrieves the target collimation values for a given body part and projection.
///
/// Returns default values if no specific target is defined for the combination.
Map<String, double> getTargetCollimationValues(
  String bodyPartId,
  String projectionName,
) {
  // Use a combined key or nested structure for more specific targets
  final key = '${bodyPartId.toLowerCase()}_${projectionName.toLowerCase()}';

  // Return specific targets if found, otherwise return default
  return _targetData[key] ?? _defaultTargets;
}
