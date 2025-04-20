import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../models/challenge.dart';
import '../models/challenge_step.dart';
import '../state/challenge_state.dart';
import '../controllers/challenge_controller.dart';
import '../widgets/positioning_selection_widget.dart';
import '../widgets/ir_size_quiz_widget.dart'; // New import
import '../widgets/ir_orientation_quiz_widget.dart'; // New import
import '../widgets/patient_position_quiz_widget.dart'; // New import
import '../../practice/widgets/collimation_painter.dart';
import '../../practice/widgets/collimation_controls_widget.dart';
import '../../practice/models/collimation_state.dart';
import '../../practice/models/body_region.dart'; // Import BodyRegions

// Provider to get the specific challenge instance for this screen
final activeChallengeProvider = Provider<Challenge>((ref) {
  throw UnimplementedError(); // Override in route
});

class ChallengeActiveScreen extends ConsumerStatefulWidget {
  final String challengeId;
  const ChallengeActiveScreen({super.key, required this.challengeId});

  @override
  ConsumerState<ChallengeActiveScreen> createState() =>
      _ChallengeActiveScreenState();
}

class _ChallengeActiveScreenState extends ConsumerState<ChallengeActiveScreen> {
  @override
  void initState() {
    super.initState();
    // Reset and Start the challenge when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure the widget is still mounted before accessing ref
      if (!mounted) return;
      final challenge = ref.read(activeChallengeProvider);
      final notifier = ref.read(
        challengeControllerProvider(challenge).notifier,
      );

      // Reset the controller's state first
      notifier.resetChallenge();

      // Then start the challenge
      notifier.startChallenge();
    });
  }

  @override
  Widget build(BuildContext context) {
    final challenge = ref.watch(activeChallengeProvider);
    final challengeState = ref.watch(challengeControllerProvider(challenge));
    final challengeNotifier = ref.read(
      challengeControllerProvider(challenge).notifier,
    );

    // Define the gradient (matching the one from challenge_screen.dart)
    final Gradient? appBarGradient =
        challenge.isTodaysChallenge
            ? LinearGradient(
              colors: [
                AppTheme.primaryColor.withAlpha((255 * 0.8).round()),
                AppTheme.accentColor.withAlpha((255 * 0.6).round()),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
            : null; // No gradient if not today's challenge

    // Use default background color if no gradient
    final appBarBackgroundColor =
        appBarGradient == null
            ? (challenge.backgroundColor ?? AppTheme.primaryColor)
            : null; // Set to null if gradient is used

    // Listen for status changes to show results dialog
    ref.listen<ChallengeState>(challengeControllerProvider(challenge), (
      prev,
      next,
    ) {
      // Ensure widget is mounted before showing dialog
      if (!mounted) return;
      // Only show dialog when status changes *to* a completed state
      if (prev?.status != next.status &&
          (next.status == ChallengeStatus.completedSuccess ||
              next.status == ChallengeStatus.completedFailureTime)) {
        // Pass the final score from the state to the dialog function
        _showResultDialog(context, next.status, next.score, challengeNotifier);
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(challenge.title),
        // Apply gradient via flexibleSpace, or use backgroundColor
        flexibleSpace:
            appBarGradient != null
                ? Container(decoration: BoxDecoration(gradient: appBarGradient))
                : null,
        backgroundColor: appBarBackgroundColor,
        foregroundColor: Colors.white, // Keep text white for contrast
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          // Prevent going back during challenge? Or ask confirmation?
          onPressed: () => context.pop(),
        ),
        actions: [
          // Timer Display
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(
                  SolarIconsOutline.clockCircle,
                  color: Colors.white.withAlpha((255 * 0.8).round()),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDuration(challengeState.remainingTime),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _buildStepWidget(context, challengeState, challengeNotifier),
    );
  }

  Widget _buildStepWidget(
    BuildContext context,
    ChallengeState challengeState,
    ChallengeController notifier,
  ) {
    final step = challengeState.currentStep;

    if (challengeState.status != ChallengeStatus.inProgress || step == null) {
      // Show loading or initial state before challenge starts
      return const Center(child: CircularProgressIndicator());
    }

    // --- Handle Different Step Types ---

    if (step is PositioningSelectionStep) {
      return PositioningSelectionWidget(
        step: step,
        onSelected: (index) => notifier.selectPositioningAnswer(index),
        selectedIndex: challengeState.selectedPositioningIndex,
      );
    }

    if (step is IRSizeQuizStep) {
      // New
      return IRSizeQuizWidget(
        step: step,
        onSelected: (index) => notifier.selectIRSizeAnswer(index),
        selectedIndex: challengeState.selectedIRSizeIndex,
      );
    }

    if (step is IROrientationQuizStep) {
      // New
      return IROrientationQuizWidget(
        step: step,
        onSelected: (index) => notifier.selectIROrientationAnswer(index),
        selectedIndex: challengeState.selectedIROrientationIndex,
      );
    }

    if (step is PatientPositionQuizStep) {
      // New
      return PatientPositionQuizWidget(
        step: step,
        onSelected: (index) => notifier.selectPatientPositionAnswer(index),
        selectedIndex: challengeState.selectedPatientPositionIndex,
      );
    }

    if (step is CollimationStep) {
      // Use practice screen's layout structure for collimation
      final colState = ref.watch(collimationStateProvider);
      // TODO: Dynamically determine imageAsset based on step.bodyPartId/projectionName
      // For now, using the placeholder:
      final imageAsset = _getImagePathForCollimation(
        step.bodyPartId,
        step.projectionName,
      );

      // Create params needed for controls widget
      final params = (
        bodyPartId: step.bodyPartId,
        projectionName: step.projectionName,
      );

      // Simplified layout for collimation step without tabs or accuracy overlay
      return Column(
        children: [
          // Optional Instruction Text
          if (step.instruction != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                step.instruction!,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16.0,
              8.0,
              16.0,
              8.0,
            ), // Adjusted top padding
            // Remove AspectRatio wrapper
            child: Container(
              height: 400, // Adjusted height slightly
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      imageAsset, // Use the determined path
                      fit: BoxFit.contain, // Changed fit to contain
                      errorBuilder:
                          (context, error, stackTrace) => const Center(
                            // Consistent placeholder icon
                            child: Icon(
                              Icons.image_not_supported,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: CollimationPainter(
                            width: colState.width,
                            height: colState.height,
                            centerX: colState.centerX,
                            centerY: colState.centerY,
                            angle: colState.angle, // Pass the angle here
                          ),
                        ),
                      ),
                    ),
                    // Accuracy overlay removed for challenge screen
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: CollimationControlsWidget(
              params: params, // Pass the params record
            ),
          ),
          // Add Submit Button for Collimation Step
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                // Corrected Icon: Use checkCircle or similar
                icon: const Icon(SolarIconsBold.checkCircle),
                label: const Text('Submit Collimation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => notifier.submitCollimation(),
              ),
            ),
          ),
        ],
      );
    }

    // Fallback for unknown step type
    return Center(
      child: Text('Unknown challenge step type: ${step.runtimeType}'),
    );
  }

  // Helper to format duration (MM:SS)
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // Show result dialog - Updated with improved UI
  void _showResultDialog(
    BuildContext context,
    ChallengeStatus status,
    int finalScore, // Added final score parameter
    ChallengeController notifier,
  ) {
    String title;
    String message;
    IconData icon;
    Color color;
    Color backgroundColor;

    switch (status) {
      case ChallengeStatus.completedSuccess:
        title = 'Challenge Complete!';
        message = 'Great job! You successfully completed the challenge.';
        icon = SolarIconsBold.checkCircle;
        color = Colors.green.shade700;
        backgroundColor = Colors.green.shade50;
        break;
      case ChallengeStatus.completedFailureTime:
        title = 'Time\'s Up!';
        message = 'You ran out of time for this challenge.';
        icon = SolarIconsBold.alarmTurnOff;
        color = Colors.orange.shade700;
        backgroundColor = Colors.orange.shade50;
        break;
      default:
        return; // Don't show dialog for other statuses
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: backgroundColor,
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            title: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 60),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                // Display Final Score with enhanced UI
                Text(
                  'Final Score', // Label for the score
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: color.withOpacity(0.3), width: 1),
                  ),
                  child: Text(
                    '$finalScore',
                    style: TextStyle(
                      fontSize: 36, // Larger font for score
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                // TODO: Add more details like breakdown per step later
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: const EdgeInsets.only(bottom: 20),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color, // Button color matches status
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  if (context.canPop()) {
                    context.pop(); // Go back from active challenge screen
                  }
                },
                child: const Text('OK', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
    );
  }

  // Helper function to get image path (Placeholder - needs proper implementation)
  String _getImagePathForCollimation(String bodyPartId, String projectionName) {
    // TODO: Implement logic to map bodyPartId and projectionName to the correct image asset path
    // This might involve looking up data similar to how it's done in CollimationPracticeScreen
    // For now, return the placeholder or a specific example
    if (bodyPartId == 'forearm' && projectionName == 'AP') {
      return 'assets/images/practice/forearm/forearm_ap.webp';
    }
    // Add more mappings as needed...
    return 'assets/images/alarp_icon.png'; // Default placeholder
  }
}
