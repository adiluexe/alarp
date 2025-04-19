// Defines the target collimation values for different body part/projection combinations.

// Example target data structure (replace/expand with your actual data)
const Map<String, Map<String, double>> _targetData = {
  // Forearm (Updated)
  'forearm_ap': {
    'width': 0.3,
    'height': 0.5,
    'centerX': 0.1,
    'centerY': 0.2,
    'angle': 0.0,
  },
  'forearm_lateral': {
    'width': 0.3,
    'height': 0.5,
    'centerX': -0.1,
    'centerY': -0.7,
    'angle': 0.0,
  },

  // Shoulder (Updated)
  'shoulder_ap_external_rotation': {
    'width': 0.5,
    'height': 0.3,
    'centerX': -0.2, // Updated horizontal
    'centerY': -0.7, // Updated vertical
    'angle': 0.0,
  },
  'shoulder_ap_internal_rotation': {
    'width': 0.6, // Updated width
    'height': 0.3,
    'centerX': -0.4,
    'centerY': -0.7, // Updated vertical
    'angle': 0.0,
  },
  'shoulder_ap_neutral_rotation': {
    'width': 0.5,
    'height': 0.3,
    'centerX': -0.4,
    'centerY': -0.8, // Updated vertical
    'angle': 0.0,
  },
  'shoulder_scapular_y': {
    'width': 0.5,
    'height': 0.3,
    'centerX': -0.6,
    'centerY': -0.4,
    'angle': 0.0,
  },
  'shoulder_transthoracic': {
    'width': 0.4,
    'height': 0.4,
    'centerX': -0.1, // Updated horizontal
    'centerY': 0.1,
    'angle': 0.0,
  },

  // Humerus (Updated - using 'humerus_ap' and 'humerus_lateral' keys)
  'humerus_ap_upright': {
    // Changed key from humerus_ap_upright
    'width': 0.3, // Updated width
    'height': 0.4, // Updated height
    'centerX': -0.3, // Updated horizontal
    'centerY': -0.4, // Updated vertical
    'angle': 0.0,
  },
  'humerus_lateral_upright': {
    // Changed key from humerus_lateral_upright
    'width': 0.4,
    'height': 0.4,
    'centerX': 0.0, // Updated horizontal
    'centerY': -0.2,
    'angle': 0.0,
  },

  // Elbow (Updated & Added)
  'elbow_ap': {
    'width': 0.2, // Updated width
    'height': 0.2, // Updated height (assuming typo 'heigth')
    'centerX': 0.1, // Updated horizontal
    'centerY': 0.3, // Updated vertical
    'angle': 0.0,
  },
  'elbow_ap_oblique_lateral_rotation': {
    // New
    'width': 0.3,
    'height': 0.3, // Assuming typo 'heigth'
    'centerX': 0.0,
    'centerY': 0.6,
    'angle': 0.0,
  },
  'elbow_ap_oblique_medial_rotation': {
    // New
    'width': 0.3,
    'height': 0.3, // Assuming typo 'heigth'
    'centerX': -0.1,
    'centerY': 0.5,
    'angle': 0.0,
  },
  'elbow_lateral': {
    // New
    'width': 0.3,
    'height': 0.2, // Assuming typo 'heigth'
    'centerX': -0.1,
    'centerY': -0.7,
    'angle': 0.0,
  },

  // Wrist (New)
  'wrist_ap': {
    'width': 0.3,
    'height': 0.4,
    'centerX': -0.0,
    'centerY': 0.1,
    'angle': 0.0,
  },
  'wrist_ap_oblique': {
    'width': 0.3,
    'height': 0.4,
    'centerX': -0.0,
    'centerY': 0.1,
    'angle': 0.0,
  },
  'wrist_lateral': {
    'width': 0.3,
    'height': 0.4,
    'centerX': -0.1,
    'centerY': 0.2,
    'angle': 0.0,
  },
  'wrist_pa': {
    'width': 0.3,
    'height': 0.4,
    'centerX': -0.1,
    'centerY': -0.2,
    'angle': 0.0,
  },
  'wrist_pa_oblique': {
    'width': 0.4,
    'height': 0.4,
    'centerX': -0.0,
    'centerY': 0.1,
    'angle': 0.0,
  },
  'wrist_pa_radial_deviation': {
    'width': 0.3,
    'height': 0.4,
    'centerX': 0.1,
    'centerY': 0.4,
    'angle': 0.0,
  },
  'wrist_pa_ulnar_deviation': {
    'width': 0.4,
    'height': 0.4,
    'centerX': -0.1,
    'centerY': 0.3,
    'angle': 0.0,
  },

  // Hand (New)
  'hand_lateral': {
    'width': 0.5,
    'height': 0.5, // Assuming typo 'heigth'
    'centerX': 0.2,
    'centerY': -0.4,
    'angle': 0.0,
  },
  'hand_norgaard': {
    'width': 0.3,
    'height': 0.3, // Assuming typo 'heigth'
    'centerX': 0.0,
    'centerY': 0.6,
    'angle': 0.0,
  },
  'hand_pa': {
    'width': 0.4,
    'height': 0.5, // Assuming typo 'heigth'
    'centerX': 0.1,
    'centerY': 0.0,
    'angle': 0.0,
  },
  'hand_pa_oblique': {
    'width': 0.3,
    'height': 0.3, // Assuming typo 'heigth'
    'centerX': 0.4,
    'centerY': -0.1,
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
  // Wrist
  'wrist_ap': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),
  'wrist_ap_oblique': TargetInfo(
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

  // Forearm
  'forearm_ap': TargetInfo(
    irSize: '7x17',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),
  'forearm_lateral': TargetInfo(
    irSize: '7x17',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),

  // Shoulder
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
  ), // Corrected typo 'legthwise'
  // Humerus
  'humerus_ap_upright': TargetInfo(
    irSize: '14x17',
    irOrientation: 'crosswise',
    pxPosition: 'standing',
  ),
  'humerus_lateral_upright': TargetInfo(
    irSize: '14x17',
    irOrientation: 'crosswise',
    pxPosition: 'standing',
  ),

  // Hand
  'hand_lateral': TargetInfo(
    irSize: '10x12',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated',
  ),
  'hand_norgaard': TargetInfo(
    irSize: '10x12',
    irOrientation: 'crosswise',
    pxPosition: 'Seated',
  ),
  'hand_pa': TargetInfo(
    irSize: '10x12',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated',
  ),
  'hand_pa_oblique': TargetInfo(
    irSize: '10x12',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated',
  ),

  // Elbow
  'elbow_ap': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated',
  ),
  'elbow_ap_oblique_lateral_rotation': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated',
  ),
  'elbow_ap_oblique_medial_rotation': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated',
  ),
  'elbow_lateral': TargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated',
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
