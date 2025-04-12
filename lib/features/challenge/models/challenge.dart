import 'package:flutter/material.dart';
import 'challenge_step.dart';

// Placeholder image path
const String _placeholderImage = 'assets/images/alarp_icon.png';

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
  });

  // --- Placeholder Data ---
  static final Challenge apForearmChallenge = Challenge(
    id: 'ch_ap_forearm_01',
    title: 'AP Forearm Positioning',
    description:
        'Select the correct AP Forearm position and collimate accurately within the time limit.',
    difficulty: 'Intermediate',
    timeLimit: const Duration(minutes: 1, seconds: 30), // 90 seconds total
    regionId: 'upper_extremity', // Added: Specify the region
    bodyPartId: 'forearm', // Matches BodyPart ID
    projectionName: 'AP', // Matches Projection Name
    backgroundColor: Colors.blueGrey, // Example color
    steps: [
      PositioningSelectionStep(
        instruction:
            'Select the image showing the correct AP Forearm position.',
        imageOptions: [
          // Use placeholder image paths
          _placeholderImage,
          _placeholderImage, // Assume this is correct
          _placeholderImage,
          _placeholderImage,
        ],
        correctImageIndex: 1, // Index of the correct image
      ),
      CollimationStep(
        bodyPartId: 'forearm', // Pass necessary info
        projectionName: 'AP',
        // Target values will be fetched by CollimationController using projectionName
      ),
    ],
  );

  // --- Add more static challenges later ---
  static Challenge getChallengeById(String id) {
    // In a real app, fetch from a list or DB
    if (id == apForearmChallenge.id) {
      return apForearmChallenge;
    }
    throw Exception('Challenge with id $id not found');
  }
}
