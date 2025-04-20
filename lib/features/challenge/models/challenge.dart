import 'package:flutter/material.dart';
import 'challenge_step.dart';

// Placeholder image path
const String _handLateral = 'assets/images/practice/hand/hand_lateral.webp';
const String _elbowLateral = 'assets/images/practice/elbow/elbow_lateral.webp';
const String _elbowAP = 'assets/images/practice/elbow/elbow_ap.webp';
// Define the specific image path
const String _apForearmCorrectImage =
    'assets/images/practice/forearm/forearm_ap.webp';

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
          'assets/images/challenge/ap_forearm.webp', // Correct
          'assets/images/challenge/ap_elbow.webp', // Incorrect
          'assets/images/challenge/lateral_elbow.webp', // Incorrect
          'assets/images/challenge/lateral_forearm.webp', // Incorrect
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

  static List<Challenge> get challenges => [
    apForearmChallenge,
    forearmApChallenge,
  ];

  static Challenge? getChallengeById(String id) {
    try {
      return challenges.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
