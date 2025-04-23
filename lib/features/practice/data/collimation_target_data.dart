// Defines the target collimation values for different body part/projection combinations.

// Example target data structure (replace/expand with your actual data)
const Map<String, Map<String, double>> _targetData = {
  // Forearm (Updated)
  'forearm_ap': {
    'width': 0.53, // Updated
    'height': 0.92, // Updated
    'centerX': 0.16, // Updated horizontal
    'centerY': 0.19, // Updated vertical
    'angle': 0.0,
  },
  'forearm_lateral': {
    'width': 0.48, // Updated
    'height': 0.87, // Updated
    'centerX': 0.15, // Updated horizontal
    'centerY': -0.28, // Updated vertical
    'angle': 0.0,
  },

  // Shoulder (Updated)
  'shoulder_ap_external_rotation': {
    'width': 0.46, // Updated
    'height': 0.28, // Updated
    'centerX': -0.25, // Updated horizontal
    'centerY': -0.71, // Updated vertical
    'angle': 0.0,
  },
  'shoulder_ap_internal_rotation': {
    'width': 0.47, // Updated
    'height': 0.25, // Updated
    'centerX': -0.39, // Updated horizontal
    'centerY': -0.69, // Updated vertical
    'angle': 0.0,
  },
  'shoulder_ap_neutral_rotation': {
    'width': 0.47, // Updated
    'height': 0.25, // Updated
    'centerX': -0.41, // Updated horizontal
    'centerY': -0.75, // Updated vertical
    'angle': 0.0,
  },
  'shoulder_scapular_y': {
    'width': 0.52, // Updated
    'height': 0.31, // Updated
    'centerX': -0.58, // Updated horizontal
    'centerY': -0.20, // Updated vertical
    'angle': 0.0,
  },
  'shoulder_transthoracic': {
    'width': 0.75, // Updated
    'height': 0.83, // Updated
    'centerX': -0.49, // Updated horizontal
    'centerY': -0.27, // Updated vertical
    'angle': 0.0,
  },

  // Humerus (Updated - using existing keys)
  'humerus_ap_upright': {
    'width': 0.57, // Updated
    'height': 0.79, // Updated
    'centerX': -0.15, // Updated horizontal
    'centerY': -0.09, // Updated vertical
    'angle': 0.0,
  },
  'humerus_lateral_upright': {
    'width': 0.73, // Updated
    'height': 0.70, // Updated
    'centerX': 0.76, // Updated horizontal
    'centerY': -0.27, // Updated vertical
    'angle': 0.0,
  },

  // Elbow (Updated)
  'elbow_ap': {
    'width': 0.53, // Updated
    'height': 0.54, // Updated
    'centerX': 0.13, // Updated horizontal
    'centerY': 0.14, // Updated vertical
    'angle': 0.0,
  },
  'elbow_ap_oblique_lateral_rotation': {
    'width': 0.53, // Updated
    'height': 0.57, // Updated
    'centerX': 0.05, // Updated horizontal
    'centerY': 0.09, // Updated vertical
    'angle': 0.0,
  },
  'elbow_ap_oblique_medial_rotation': {
    'width': 0.51, // Updated
    'height': 0.57, // Updated
    'centerX': -0.11, // Updated horizontal
    'centerY': 0.09, // Updated vertical
    'angle': 0.0,
  },
  'elbow_lateral': {
    'width': 0.67, // Updated
    'height': 0.55, // Updated
    'centerX': 0.01, // Updated horizontal
    'centerY': -0.42, // Updated vertical
    'angle': 0.0,
  },

  // Wrist (Updated)
  'wrist_ap': {
    'width': 0.36, // Updated
    'height': 0.46, // Updated
    'centerX': -0.13, // Updated horizontal
    'centerY': -0.04, // Updated vertical
    'angle': 0.0,
  },
  'wrist_ap_oblique_medial_rotation': {
    'width': 0.38, // Updated
    'height': 0.44, // Updated
    'centerX': -0.02, // Updated horizontal
    'centerY': 0.20, // Updated vertical
    'angle': 0.0,
  },
  'wrist_lateral': {
    'width': 0.37, // Updated
    'height': 0.41, // Updated
    'centerX': -0.11, // Updated horizontal
    'centerY': 0.35, // Updated vertical
    'angle': 0.0,
  },
  'wrist_pa': {
    'width': 0.35, // Updated
    'height': 0.41, // Updated
    'centerX': -0.15, // Updated horizontal
    'centerY': 0.11, // Updated vertical
    'angle': 0.0,
  },
  'wrist_pa_oblique': {
    'width': 0.40, // Updated
    'height': 0.43, // Updated
    'centerX': 0.01, // Updated horizontal
    'centerY': 0.29, // Updated vertical
    'angle': 0.0,
  },
  'wrist_pa_radial_deviation': {
    'width': 0.38, // Updated
    'height': 0.45, // Updated
    'centerX': 0.15, // Updated horizontal
    'centerY': 0.33, // Updated vertical
    'angle': 0.0,
  },
  'wrist_pa_ulnar_deviation': {
    'width': 0.48, // Updated
    'height': 0.49, // Updated
    'centerX': -0.16, // Updated horizontal
    'centerY': 0.39, // Updated vertical
    'angle': 0.0,
  },

  // Hand (Updated)
  'hand_lateral': {
    'width': 0.59, // Updated
    'height': 0.62, // Updated
    'centerX': 0.29, // Updated horizontal
    'centerY': -0.16, // Updated vertical
    'angle': 0.0,
  },
  'hand_norgaard': {
    'width': 0.78, // Updated
    'height': 0.44, // Updated
    'centerX': -0.30, // Updated horizontal
    'centerY': -0.09, // Updated vertical
    'angle': 0.0,
  },
  'hand_pa': {
    'width': 0.59, // Updated
    'height': 0.61, // Updated
    'centerX': 0.25, // Updated horizontal
    'centerY': 0.19, // Updated vertical
    'angle': 0.0,
  },
  'hand_pa_oblique': {
    'width': 0.59, // Updated
    'height': 0.59, // Updated
    'centerX': 0.53, // Updated horizontal
    'centerY': 0.05, // Updated vertical
    'angle': 0.0,
  },

  // Add all other bodyPart_projection combinations here...
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
  final key =
      '${bodyPartId.toLowerCase()}_${projectionName.toLowerCase().replaceAll(' ', '_').replaceAll('(', '').replaceAll(')', '')}'; // Standardize key

  // Return specific targets if found, otherwise return default
  return _targetData[key] ?? _defaultTargets;
}

// --- New Data Structure and Function for Extra Info ---

// Structure to hold the extra textual information
class TargetInfo {
  final String irSize;
  final String irOrientation;
  final String pxPosition;

  const TargetInfo({
    this.irSize = 'N/A',
    this.irOrientation = 'N/A',
    this.pxPosition = 'N/A',
  });
}

// Map to store the extra info
const Map<String, TargetInfo> _targetInfoData = {
  // Wrist (Updated)
  'wrist_ap': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),
  'wrist_ap_oblique_medial_rotation': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),
  'wrist_lateral': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),
  'wrist_pa': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),
  'wrist_pa_oblique': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),
  'wrist_pa_radial_deviation': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),
  'wrist_pa_ulnar_deviation': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),

  // Forearm (Updated)
  'forearm_ap': TargetInfo(
    irSize: '14x17 divided', // Updated
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),
  'forearm_lateral': TargetInfo(
    irSize: '14x17 divided', // Updated
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),

  // Shoulder (Updated)
  'shoulder_ap_external_rotation': TargetInfo(
    irSize: '10x12',
    irOrientation: 'crosswise',
    pxPosition: 'standing',
  ),
  'shoulder_ap_internal_rotation': TargetInfo(
    irSize: '10x12',
    irOrientation: 'crosswise',
    pxPosition: 'standing',
  ),
  'shoulder_ap_neutral_rotation': TargetInfo(
    irSize: '10x12',
    irOrientation: 'crosswise',
    pxPosition: 'standing',
  ),
  'shoulder_scapular_y': TargetInfo(
    irSize: '10x12',
    irOrientation: 'crosswise',
    pxPosition: 'standing',
  ),
  'shoulder_transthoracic': TargetInfo(
    irSize: '10x12',
    irOrientation: 'lengthwise',
    pxPosition: 'standing',
  ),
  // Humerus (Updated)
  'humerus_ap_upright': TargetInfo(
    irSize: '14x17', // Updated
    irOrientation: 'crosswise',
    pxPosition: 'standing',
  ),
  'humerus_lateral_upright': TargetInfo(
    irSize: '14x17', // Updated
    irOrientation: 'crosswise',
    pxPosition: 'standing',
  ),

  // Hand (Updated)
  'hand_lateral': TargetInfo(
    irSize: '10x12',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated', // Standardized capitalization
  ),
  'hand_norgaard': TargetInfo(
    irSize: '10x12',
    irOrientation: 'crosswise',
    pxPosition: 'Seated', // Standardized capitalization
  ),
  'hand_pa': TargetInfo(
    irSize: '10x12',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated', // Standardized capitalization
  ),
  'hand_pa_oblique': TargetInfo(
    irSize: '10x12',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated', // Standardized capitalization
  ),

  // Elbow (Updated)
  'elbow_ap': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated', // Standardized capitalization
  ),
  'elbow_ap_oblique_lateral_rotation': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated', // Standardized capitalization
  ),
  'elbow_ap_oblique_medial_rotation': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated', // Standardized capitalization
  ),
  'elbow_lateral': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated', // Standardized capitalization
  ),
};

// Default info if no specific target is found
const TargetInfo _defaultTargetInfo = TargetInfo();

/// Retrieves the target information (IR size, orientation, position) for a given body part and projection.
///
/// Returns default values if no specific target info is defined for the combination.
TargetInfo getTargetInfo(String bodyPartId, String projectionName) {
  // Use the same standardized key as getTargetCollimationValues
  final key =
      '${bodyPartId.toLowerCase()}_${projectionName.toLowerCase().replaceAll(' ', '_').replaceAll('(', '').replaceAll(')', '')}';
  return _targetInfoData[key] ?? _defaultTargetInfo;
}
