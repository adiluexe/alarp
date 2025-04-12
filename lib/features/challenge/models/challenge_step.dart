/// Base class for a step within a challenge.
abstract class ChallengeStep {
  const ChallengeStep();
}

/// Step for selecting the correct positioning image.
class PositioningSelectionStep extends ChallengeStep {
  final String instruction;
  final List<String> imageOptions; // List of asset paths for image choices
  final int correctImageIndex; // Index of the correct image in the list

  const PositioningSelectionStep({
    required this.instruction,
    required this.imageOptions,
    required this.correctImageIndex,
  });
}

/// Step for performing collimation.
class CollimationStep extends ChallengeStep {
  final String bodyPartId;
  final String projectionName;
  // Target values are implicitly defined by the projectionName
  // and handled by the CollimationController

  const CollimationStep({
    required this.bodyPartId,
    required this.projectionName,
  });
}

// Add other step types later if needed (e.g., Anatomy ID, Evaluation)
