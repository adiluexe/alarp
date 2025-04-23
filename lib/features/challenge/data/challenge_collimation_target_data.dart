// filepath: d:\Development\alarp\lib\features\challenge\data\challenge_collimation_target_data.dart
// Defines the target collimation values for CHALLENGE mode.

// Example target data structure for Challenge
const Map<String, Map<String, double>> _challengeTargetData = {
  // Hand
  'hand_lateral': {
    'width': 0.40,
    'height': 0.60,
    'centerX': 0.0, // horizontal center
    'centerY': -0.15, // vertical center
    'angle': 0.0, // Default angle if not specified
  },

  // Wrist
  'wrist_ap': {
    'width': 0.32,
    'height': 0.41,
    'centerX': -0.01, // horizontal
    'centerY': 0.17, // vertical
    'angle': 0.0,
  },
  'wrist_ap_oblique': {
    'width': 0.36,
    'height': 0.44,
    'centerX': 0.28, // horizontal
    'centerY': 0.30, // vertical
    'angle': 0.0,
  },
  'wrist_lateral': {
    'width': 0.29,
    'height': 0.42,
    'centerX': -0.03, // horizontal
    'centerY': 0.11, // vertical
    'angle': 0.0,
  },
  'wrist_pa': {
    'width': 0.34,
    'height': 0.38,
    'centerX': 0.15, // horizontal
    'centerY': 0.45, // vertical
    'angle': 0.0,
  },

  // Forearm
  'forearm_ap': {
    'width': 0.32,
    'height': 0.55,
    'centerX': 0.31, // horizontal
    'centerY': 0.52, // vertical
    'angle': 0.0,
  },
  'forearm_lateral': {
    'width': 0.31,
    'height': 0.67,
    'centerX': 0.11, // horizontal
    'centerY': -0.64, // vertical
    'angle': 0.0,
  },

  // Elbow
  'elbow_ap': {
    'width': 0.36,
    'height': 0.36,
    'centerX': 0.00, // Horizontal
    'centerY': 0.54, // Vertical
    'angle': 0.0,
  },
  'elbow_ap_oblique_lateral': {
    'width': 0.34,
    'height': 0.41,
    'centerX': 0.00, // Horizontal
    'centerY': 0.89, // Vertical
    'angle': 0.0,
  },
  'elbow_ap_oblique_medial': {
    'width': 0.36,
    'height': 0.41,
    'centerX': -0.01, // Horizontal
    'centerY': 0.69, // Vertical
    'angle': 0.0,
  },
  'elbow_lateral': {
    'width': 0.64,
    'height': 0.55,
    'centerX': 0.15, // Horizontal
    'centerY': -0.44, // Vertical
    'angle': 0.0,
  },

  // Shoulder
  'shoulder_scap_y': {
    'width': 0.72, // Assuming 0.0 if blank
    'height': 0.45,
    'centerX': -0.53, // horizontal
    'centerY': 0.92, // vertical
    'angle': 0.0,
  },
  'shoulder_transthoracic': {
    'width': 0.55,
    'height': 0.70,
    'centerX': -0.50, // horizontal
    'centerY': 0.50, // vertical
    'angle': 0.0,
  },

  // Humerus
  'humerus_ap': {
    'width': 0.50,
    'height': 0.61,
    'centerX': 0.19, // horizontal
    'centerY': -0.15, // vertical
    'angle': 0.0,
  },
  'humerus_lateral': {
    'width': 0.51,
    'height': 0.59,
    'centerX': 0.01, // horizontal
    'centerY': -0.22, // vertical
    'angle': 0.0,
  },
};

// Default values if no specific challenge target is found
const Map<String, double> _defaultChallengeTargets = {
  'width': 0.5,
  'height': 0.5,
  'centerX': 0.0,
  'centerY': 0.0,
  'angle': 0.0,
};

/// Retrieves the CHALLENGE target collimation values for a given body part and projection.
///
/// Returns default values if no specific target is defined for the combination.
Map<String, double> getChallengeTargetCollimationValues(
  String bodyPartId,
  String projectionName,
) {
  final key =
      '${bodyPartId.toLowerCase()}_${projectionName.toLowerCase().replaceAll(' ', '_').replaceAll('(', '').replaceAll(')', '')}'; // Standardize key
  return _challengeTargetData[key] ?? _defaultChallengeTargets;
}

// --- Data Structure and Function for Extra Info (Challenge) ---

// Structure to hold the extra textual information for Challenge
class ChallengeTargetInfo {
  final String irSize;
  final String irOrientation;
  final String pxPosition;

  const ChallengeTargetInfo({
    this.irSize = 'N/A',
    this.irOrientation = 'N/A',
    this.pxPosition = 'N/A',
  });
}

// Map to store the extra info for Challenge
const Map<String, ChallengeTargetInfo> _challengeTargetInfoData = {
  // Wrist
  'wrist_ap': ChallengeTargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),
  'wrist_ap_oblique': ChallengeTargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),
  'wrist_lateral': ChallengeTargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),
  'wrist_pa': ChallengeTargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),

  // Forearm
  'forearm_ap': ChallengeTargetInfo(
    irSize: '14x17 divided',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),
  'forearm_lateral': ChallengeTargetInfo(
    irSize: '14x17 divided',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),

  // Elbow
  'elbow_ap': ChallengeTargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated',
  ),
  'elbow_ap_oblique_lateral': ChallengeTargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated',
  ),
  'elbow_ap_oblique_medial': ChallengeTargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated',
  ),
  'elbow_lateral': ChallengeTargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'Seated',
  ),

  // Shoulder
  'shoulder_scap_y': ChallengeTargetInfo(
    irSize: '10x12',
    irOrientation: 'crosswise',
    pxPosition: 'standing',
  ),
  'shoulder_transthoracic': ChallengeTargetInfo(
    irSize: '10x12',
    irOrientation: 'lengthwise',
    pxPosition: 'standing',
  ),

  // Humerus
  'humerus_ap': ChallengeTargetInfo(
    irSize: '14x17',
    irOrientation: 'crosswise',
    pxPosition: 'standing',
  ),
  'humerus_lateral': ChallengeTargetInfo(
    irSize: '14x17',
    irOrientation: 'crosswise',
    pxPosition: 'standing',
  ),
};

// Default info if no specific challenge target is found
const ChallengeTargetInfo _defaultChallengeTargetInfo = ChallengeTargetInfo();

/// Retrieves the CHALLENGE target information (IR size, orientation, position).
///
/// Returns default values if no specific target info is defined for the combination.
ChallengeTargetInfo getChallengeTargetInfo(
  String bodyPartId,
  String projectionName,
) {
  final key =
      '${bodyPartId.toLowerCase()}_${projectionName.toLowerCase().replaceAll(' ', '_').replaceAll('(', '').replaceAll(')', '')}';
  return _challengeTargetInfoData[key] ?? _defaultChallengeTargetInfo;
}
