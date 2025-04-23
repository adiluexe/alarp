// filepath: d:\Development\alarp\lib\features\challenge\data\challenge_collimation_target_data.dart
// Defines the target collimation values for CHALLENGE mode.
// NOTE: Update the numerical values below to match the challenge images.

// Example target data structure for Challenge
const Map<String, Map<String, double>> _challengeTargetData = {
  // Forearm (Update values for Challenge)
  'forearm_ap': {
    'width': 0.53,
    'height': 0.92,
    'centerX': 0.16,
    'centerY': 0.19,
    'angle': 0.0,
  },
  'forearm_lateral': {
    'width': 0.48,
    'height': 0.87,
    'centerX': 0.15,
    'centerY': -0.28,
    'angle': 0.0,
  },

  // Shoulder (Update values for Challenge)
  'shoulder_ap_external_rotation': {
    'width': 0.46,
    'height': 0.28,
    'centerX': -0.25,
    'centerY': -0.71,
    'angle': 0.0,
  },
  // ... Add all other bodyPart_projection combinations with CHALLENGE values ...
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
// NOTE: Update these values if they differ for the challenge mode
const Map<String, ChallengeTargetInfo> _challengeTargetInfoData = {
  // Wrist (Update values for Challenge)
  'wrist_ap': ChallengeTargetInfo(
    irSize: '8x10',
    irOrientation: 'lengthwise',
    pxPosition: 'seated',
  ),
  // ... Add all other bodyPart_projection combinations with CHALLENGE info ...
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
