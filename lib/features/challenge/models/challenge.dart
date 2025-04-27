import 'package:flutter/material.dart';
import 'challenge_step.dart';

// Placeholder image path
const String _handLateral = 'assets/images/challenge/hand/hand_lateral.png';
const String _elbowLateral = 'assets/images/challenge/elbow/elbow_lateral.png';
const String _elbowAP = 'assets/images/challenge/elbow/elbow_ap.png';
// Define the specific image path
const String _apForearmCorrectImage =
    'assets/images/challenge/forearm/forearm_ap.png';

/// Represents a single challenge instance.
class Challenge {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final Duration timeLimit;
  final String regionId; // Added: e.g., 'upper_extremity'
  final String bodyPartId; // e.g., 'forearm'
  final String projectionName; // e.g., 'AP'
  final List<ChallengeStep> steps;
  final Color? backgroundColor; // Optional color for theming
  final bool isTodaysChallenge; // Added flag

  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.timeLimit,
    required this.regionId, // Added
    required this.bodyPartId,
    required this.projectionName,
    required this.steps,
    this.backgroundColor,
    this.isTodaysChallenge = false, // Default to false
  });

  // --- Placeholder Data ---
  static final Challenge apForearmChallenge = Challenge(
    id: 'ch_ap_forearm_01',
    title: 'AP Forearm Positioning',
    description:
        'Select the correct AP Forearm position and collimate accurately within the time limit.',
    difficulty: 'Beginner', // Changed back to 'Beginner'
    timeLimit: const Duration(minutes: 1, seconds: 30), // 90 seconds total
    regionId: 'upper_extremity', // Added: Specify the region
    bodyPartId: 'forearm', // Matches BodyPart ID
    projectionName: 'AP', // Matches Projection Name
    backgroundColor: Colors.blueGrey, // Example color
    isTodaysChallenge: true, // Set flag for today's challenge
    steps: [
      PositioningSelectionStep(
        id: 'step1_pos',
        question: 'Select the correct AP Forearm position:',
        imageAssets: [
          _handLateral,
          _apForearmCorrectImage, // Use the specific correct image path
          _elbowLateral,
          _elbowAP,
        ],
        correctAnswerIndex: 1, // Index of the correct image
        instruction: 'Step 1: Choose the Positioning',
      ),
      CollimationStep(
        id: 'step5_collimation',
        bodyPartId: 'forearm', // Pass necessary info
        projectionName: 'AP',
        instruction: 'Step 5: Adjust Collimation',
      ),
    ],
  );

  static final Challenge forearmApChallenge = Challenge(
    id: 'forearm_ap_1',
    title: 'Forearm AP Basics',
    description: 'Positioning and Collimation for Forearm AP',
    difficulty: 'Beginner',
    timeLimit: const Duration(minutes: 3), // Updated time limit
    regionId: 'upper_limb', // Example region ID
    bodyPartId: 'forearm', // Example body part ID
    projectionName: 'AP',
    steps: [
      PositioningSelectionStep(
        id: 'step1_pos',
        question: 'Select the correct AP Forearm position:',
        imageAssets: [
          'assets/images/challenge/ap_forearm.png', // Correct
          'assets/images/challenge/ap_elbow.png', // Incorrect
          'assets/images/challenge/lateral_elbow.png', // Incorrect
          'assets/images/challenge/lateral_forearm.png', // Incorrect
        ],
        correctAnswerIndex: 0,
        instruction: 'Step 1: Choose the Positioning',
      ),
      IRSizeQuizStep(
        id: 'step2_ir_size',
        options: ["8x10\"", "10x12\"", "14x17\" divided", "14x17\""],
        correctAnswerIndex: 2, // Index for "14x17 divided\""
        instruction: 'Step 2: Select IR Size',
      ),
      IROrientationQuizStep(
        id: 'step3_ir_orient',
        options: ["Crosswise", "Lengthwise"],
        correctAnswerIndex: 1, // Index for "Lengthwise"
        instruction: 'Step 3: Select IR Orientation',
      ),
      PatientPositionQuizStep(
        id: 'step4_px_pos',
        options: ["Upright", "Seated"],
        correctAnswerIndex: 1, // Index for "Seated"
        instruction: 'Step 4: Select Patient Position',
      ),
      CollimationStep(
        id: 'step5_collimation',
        bodyPartId: 'forearm',
        projectionName: 'AP',
        instruction: 'Step 5: Adjust Collimation',
      ),
    ],
  );

  static final Challenge upperExtremitiesChallenge = Challenge(
    id: 'upper_extremities_10rounds',
    title: 'Upper Extremities Challenge',
    description:
        'Test your knowledge of upper extremity positioning and collimation across 10 projections. Each round features 5 steps: Positioning, IR Size, IR Orientation, Patient Position, and Collimation.',
    difficulty: 'Intermediate',
    timeLimit: const Duration(minutes: 10),
    regionId: 'upper_extremity',
    bodyPartId: 'multi',
    projectionName: 'multi',
    backgroundColor: Colors.indigo,
    steps: [
      // 1. Forearm AP
      PositioningSelectionStep(
        id: '1_pos',
        question: 'Select the correct AP Forearm position:',
        imageAssets: [
          'assets/images/challenge/forearm/forearm_lateral.png',
          'assets/images/challenge/forearm/forearm_ap.png',
          'assets/images/challenge/elbow/elbow_ap.png',
          'assets/images/challenge/hand/hand_pa.png',
        ],
        correctAnswerIndex: 1,
        instruction: 'Step 1: Choose Positioning for Forearm AP',
      ),
      IRSizeQuizStep(
        id: '1_ir_size',
        options: ["8x10", "10x12", "14x17 divided", "14x17"],
        correctAnswerIndex: 2,
        instruction: 'Step 2: Select IR Size for Forearm AP',
      ),
      IROrientationQuizStep(
        id: '1_ir_orient',
        options: ["Crosswise", "Lengthwise"],
        correctAnswerIndex: 1,
        instruction: 'Step 3: Select IR Orientation for Forearm AP',
      ),
      PatientPositionQuizStep(
        id: '1_px_pos',
        options: ["Upright", "Seated"],
        correctAnswerIndex: 1,
        instruction: 'Step 4: Select Patient Position for Forearm AP',
      ),
      CollimationStep(
        id: '1_collimation',
        bodyPartId: 'forearm',
        projectionName: 'AP',
        instruction: 'Step 5: Adjust Collimation for Forearm AP',
      ),
      // 2. Forearm Lateral
      PositioningSelectionStep(
        id: '2_pos',
        question: 'Select the correct Lateral Forearm position:',
        imageAssets: [
          'assets/images/challenge/forearm/forearm_ap.png',
          'assets/images/challenge/forearm/forearm_lateral.png',
          'assets/images/challenge/elbow/elbow_lateral.png',
          'assets/images/challenge/hand/hand_lateral.png',
        ],
        correctAnswerIndex: 1,
        instruction: 'Step 1: Choose Positioning for Forearm Lateral',
      ),
      IRSizeQuizStep(
        id: '2_ir_size',
        options: ["8x10", "10x12", "14x17 divided", "14x17"],
        correctAnswerIndex: 2,
        instruction: 'Step 2: Select IR Size for Forearm Lateral',
      ),
      IROrientationQuizStep(
        id: '2_ir_orient',
        options: ["Crosswise", "Lengthwise"],
        correctAnswerIndex: 1,
        instruction: 'Step 3: Select IR Orientation for Forearm Lateral',
      ),
      PatientPositionQuizStep(
        id: '2_px_pos',
        options: ["Upright", "Seated"],
        correctAnswerIndex: 1,
        instruction: 'Step 4: Select Patient Position for Forearm Lateral',
      ),
      CollimationStep(
        id: '2_collimation',
        bodyPartId: 'forearm',
        projectionName: 'Lateral',
        instruction: 'Step 5: Adjust Collimation for Forearm Lateral',
      ),
      // 3. Elbow AP
      PositioningSelectionStep(
        id: '3_pos',
        question: 'Select the correct AP Elbow position:',
        imageAssets: [
          'assets/images/challenge/elbow/elbow_lateral.png',
          'assets/images/challenge/elbow/elbow_ap.png',
          'assets/images/challenge/forearm/forearm_ap.png',
          'assets/images/challenge/hand/hand_pa.png',
        ],
        correctAnswerIndex: 1,
        instruction: 'Step 1: Choose Positioning for Elbow AP',
      ),
      IRSizeQuizStep(
        id: '3_ir_size',
        options: ["8x10", "10x12", "14x17 divided", "14x17"],
        correctAnswerIndex: 0,
        instruction: 'Step 2: Select IR Size for Elbow AP',
      ),
      IROrientationQuizStep(
        id: '3_ir_orient',
        options: ["Crosswise", "Lengthwise"],
        correctAnswerIndex: 1,
        instruction: 'Step 3: Select IR Orientation for Elbow AP',
      ),
      PatientPositionQuizStep(
        id: '3_px_pos',
        options: ["Upright", "Seated"],
        correctAnswerIndex: 1,
        instruction: 'Step 4: Select Patient Position for Elbow AP',
      ),
      CollimationStep(
        id: '3_collimation',
        bodyPartId: 'elbow',
        projectionName: 'AP',
        instruction: 'Step 5: Adjust Collimation for Elbow AP',
      ),
      // 4. Elbow Lateral
      PositioningSelectionStep(
        id: '4_pos',
        question: 'Select the correct Lateral Elbow position:',
        imageAssets: [
          'assets/images/challenge/elbow/elbow_ap.png',
          'assets/images/challenge/elbow/elbow_lateral.png',
          'assets/images/challenge/forearm/forearm_lateral.png',
          'assets/images/challenge/hand/hand_lateral.png',
        ],
        correctAnswerIndex: 1,
        instruction: 'Step 1: Choose Positioning for Elbow Lateral',
      ),
      IRSizeQuizStep(
        id: '4_ir_size',
        options: ["8x10", "10x12", "14x17 divided", "14x17"],
        correctAnswerIndex: 0,
        instruction: 'Step 2: Select IR Size for Elbow Lateral',
      ),
      IROrientationQuizStep(
        id: '4_ir_orient',
        options: ["Crosswise", "Lengthwise"],
        correctAnswerIndex: 1,
        instruction: 'Step 3: Select IR Orientation for Elbow Lateral',
      ),
      PatientPositionQuizStep(
        id: '4_px_pos',
        options: ["Upright", "Seated"],
        correctAnswerIndex: 1,
        instruction: 'Step 4: Select Patient Position for Elbow Lateral',
      ),
      CollimationStep(
        id: '4_collimation',
        bodyPartId: 'elbow',
        projectionName: 'Lateral',
        instruction: 'Step 5: Adjust Collimation for Elbow Lateral',
      ),
      // 5. Wrist PA
      PositioningSelectionStep(
        id: '5_pos',
        question: 'Select the correct PA Wrist position:',
        imageAssets: [
          'assets/images/challenge/hand/hand_lateral.png',
          'assets/images/challenge/wrist/wrist_pa.png',
          'assets/images/challenge/hand/hand_pa.png',
          'assets/images/challenge/forearm/forearm_ap.png',
        ],
        correctAnswerIndex: 1,
        instruction: 'Step 1: Choose Positioning for Wrist PA',
      ),
      IRSizeQuizStep(
        id: '5_ir_size',
        options: ["8x10", "10x12", "14x17 divided", "14x17"],
        correctAnswerIndex: 0,
        instruction: 'Step 2: Select IR Size for Wrist PA',
      ),
      IROrientationQuizStep(
        id: '5_ir_orient',
        options: ["Crosswise", "Lengthwise"],
        correctAnswerIndex: 1,
        instruction: 'Step 3: Select IR Orientation for Wrist PA',
      ),
      PatientPositionQuizStep(
        id: '5_px_pos',
        options: ["Upright", "Seated"],
        correctAnswerIndex: 1,
        instruction: 'Step 4: Select Patient Position for Wrist PA',
      ),
      CollimationStep(
        id: '5_collimation',
        bodyPartId: 'wrist',
        projectionName: 'PA',
        instruction: 'Step 5: Adjust Collimation for Wrist PA',
      ),
      // 6. Wrist Lateral
      PositioningSelectionStep(
        id: '6_pos',
        question: 'Select the correct Lateral Wrist position:',
        imageAssets: [
          'assets/images/challenge/wrist/wrist_pa.png',
          'assets/images/challenge/wrist/wrist_lateral.png',
          'assets/images/challenge/hand/hand_lateral.png',
          'assets/images/challenge/forearm/forearm_lateral.png',
        ],
        correctAnswerIndex: 1,
        instruction: 'Step 1: Choose Positioning for Wrist Lateral',
      ),
      IRSizeQuizStep(
        id: '6_ir_size',
        options: ["8x10", "10x12", "14x17 divided", "14x17"],
        correctAnswerIndex: 0,
        instruction: 'Step 2: Select IR Size for Wrist Lateral',
      ),
      IROrientationQuizStep(
        id: '6_ir_orient',
        options: ["Crosswise", "Lengthwise"],
        correctAnswerIndex: 1,
        instruction: 'Step 3: Select IR Orientation for Wrist Lateral',
      ),
      PatientPositionQuizStep(
        id: '6_px_pos',
        options: ["Upright", "Seated"],
        correctAnswerIndex: 1,
        instruction: 'Step 4: Select Patient Position for Wrist Lateral',
      ),
      CollimationStep(
        id: '6_collimation',
        bodyPartId: 'wrist',
        projectionName: 'Lateral',
        instruction: 'Step 5: Adjust Collimation for Wrist Lateral',
      ),
      // 7. Hand PA
      PositioningSelectionStep(
        id: '7_pos',
        question: 'Select the correct PA Hand position:',
        imageAssets: [
          'assets/images/challenge/wrist/wrist_lateral.png',
          'assets/images/challenge/hand/hand_pa.png',
          'assets/images/challenge/wrist/wrist_pa.png',
          'assets/images/challenge/forearm/forearm_ap.png',
        ],
        correctAnswerIndex: 1,
        instruction: 'Step 1: Choose Positioning for Hand PA',
      ),
      IRSizeQuizStep(
        id: '7_ir_size',
        options: ["8x10", "10x12", "14x17 divided", "14x17"],
        correctAnswerIndex: 1,
        instruction: 'Step 2: Select IR Size for Hand PA',
      ),
      IROrientationQuizStep(
        id: '7_ir_orient',
        options: ["Crosswise", "Lengthwise"],
        correctAnswerIndex: 1,
        instruction: 'Step 3: Select IR Orientation for Hand PA',
      ),
      PatientPositionQuizStep(
        id: '7_px_pos',
        options: ["Upright", "Seated"],
        correctAnswerIndex: 1,
        instruction: 'Step 4: Select Patient Position for Hand PA',
      ),
      CollimationStep(
        id: '7_collimation',
        bodyPartId: 'hand',
        projectionName: 'PA',
        instruction: 'Step 5: Adjust Collimation for Hand PA',
      ),
      // 8. Hand Lateral
      PositioningSelectionStep(
        id: '8_pos',
        question: 'Select the correct Lateral Hand position:',
        imageAssets: [
          'assets/images/challenge/hand/hand_pa.png',
          'assets/images/challenge/hand/hand_lateral.png',
          'assets/images/challenge/wrist/wrist_lateral.png',
          'assets/images/challenge/forearm/forearm_lateral.png',
        ],
        correctAnswerIndex: 1,
        instruction: 'Step 1: Choose Positioning for Hand Lateral',
      ),
      IRSizeQuizStep(
        id: '8_ir_size',
        options: ["8x10", "10x12", "14x17 divided", "14x17"],
        correctAnswerIndex: 1,
        instruction: 'Step 2: Select IR Size for Hand Lateral',
      ),
      IROrientationQuizStep(
        id: '8_ir_orient',
        options: ["Crosswise", "Lengthwise"],
        correctAnswerIndex: 1,
        instruction: 'Step 3: Select IR Orientation for Hand Lateral',
      ),
      PatientPositionQuizStep(
        id: '8_px_pos',
        options: ["Upright", "Seated"],
        correctAnswerIndex: 1,
        instruction: 'Step 4: Select Patient Position for Hand Lateral',
      ),
      CollimationStep(
        id: '8_collimation',
        bodyPartId: 'hand',
        projectionName: 'Lateral',
        instruction: 'Step 5: Adjust Collimation for Hand Lateral',
      ),
      // 9. Shoulder Transthoracic
      PositioningSelectionStep(
        id: '9_pos',
        question: 'Select the correct Shoulder Transthoracic position:',
        imageAssets: [
          'assets/images/challenge/shoulder/shoulder_transthoracic.png',
          'assets/images/challenge/shoulder/shoulder_ap_external_rotation.png',
          'assets/images/challenge/shoulder/shoulder_ap_neutral_rotation.png',
          'assets/images/challenge/shoulder/shoulder_scapular_y.png',
        ],
        correctAnswerIndex: 0,
        instruction: 'Step 1: Choose Positioning for Shoulder Transthoracic',
      ),
      IRSizeQuizStep(
        id: '9_ir_size',
        options: ["8x10", "10x12", "14x17 divided", "14x17"],
        correctAnswerIndex: 1,
        instruction: 'Step 2: Select IR Size for Shoulder Transthoracic',
      ),
      IROrientationQuizStep(
        id: '9_ir_orient',
        options: ["Crosswise", "Lengthwise"],
        correctAnswerIndex: 1,
        instruction: 'Step 3: Select IR Orientation for Shoulder Transthoracic',
      ),
      PatientPositionQuizStep(
        id: '9_px_pos',
        options: ["Standing", "Seated"],
        correctAnswerIndex: 0,
        instruction:
            'Step 4: Select Patient Position for Shoulder Transthoracic',
      ),
      CollimationStep(
        id: '9_collimation',
        bodyPartId: 'shoulder',
        projectionName: 'Transthoracic',
        instruction: 'Step 5: Adjust Collimation for Shoulder Transthoracic',
      ),
      // 10. Humerus AP Upright
      PositioningSelectionStep(
        id: '10_pos',
        question: 'Select the correct AP Humerus (Upright) position:',
        imageAssets: [
          'assets/images/challenge/humerus/humerus_lateral_upright.png',
          'assets/images/challenge/humerus/humerus_ap_upright.png',
          'assets/images/challenge/shoulder/shoulder_ap_external_rotation.png',
          'assets/images/challenge/shoulder/shoulder_scapular_y.png',
        ],
        correctAnswerIndex: 1,
        instruction: 'Step 1: Choose Positioning for Humerus AP Upright',
      ),
      IRSizeQuizStep(
        id: '10_ir_size',
        options: ["8x10", "10x12", "14x17 divided", "14x17"],
        correctAnswerIndex: 3,
        instruction: 'Step 2: Select IR Size for Humerus AP Upright',
      ),
      IROrientationQuizStep(
        id: '10_ir_orient',
        options: ["Crosswise", "Lengthwise"],
        correctAnswerIndex: 1,
        instruction: 'Step 3: Select IR Orientation for Humerus AP Upright',
      ),
      PatientPositionQuizStep(
        id: '10_px_pos',
        options: ["Standing", "Seated"],
        correctAnswerIndex: 0,
        instruction: 'Step 4: Select Patient Position for Humerus AP Upright',
      ),
      CollimationStep(
        id: '10_collimation',
        bodyPartId: 'humerus',
        projectionName: 'AP Upright',
        instruction: 'Step 5: Adjust Collimation for Humerus AP Upright',
      ),
    ],
  );

  static List<Challenge> get challenges => [
    apForearmChallenge,
    forearmApChallenge,
    upperExtremitiesChallenge,
  ];

  static Challenge? getChallengeById(String id) {
    try {
      return challenges.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
