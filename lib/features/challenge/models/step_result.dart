/// Represents the outcome of a single step within a challenge.
class StepResult {
  final String stepId;
  final bool isCorrect;
  final int scoreEarned;
  final String? stepInstruction; // Optional: To display which step it was
  final double? accuracy; // Optional: For collimation steps

  const StepResult({
    required this.stepId,
    required this.isCorrect,
    required this.scoreEarned,
    this.stepInstruction,
    this.accuracy,
  });

  // Optional: Add copyWith or other helper methods if needed later
}
