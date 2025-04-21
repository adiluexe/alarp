import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/navigation/app_router.dart'; // Import AppRoutes
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

    // Listen for status changes to NAVIGATE to results screen
    ref.listen<ChallengeState>(challengeControllerProvider(challenge), (
      prev,
      next,
    ) {
      // Ensure widget is mounted before navigating
      if (!mounted) return;
      // Only navigate when status changes *to* a completed state
      if (prev?.status != next.status &&
          (next.status == ChallengeStatus.completedSuccess ||
              next.status == ChallengeStatus.completedFailureTime)) {
        // Navigate to the results screen using the named route
        // The results screen will read the state using the same provider instance
        context.goNamed(
          AppRoutes.challengeResults,
          pathParameters: {'challengeId': challenge.id},
        );
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
    final wasCorrect = challengeState.wasLastAnswerCorrect; // Get the status

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
        wasCorrect: wasCorrect, // Pass the status
      );
    }

    if (step is IRSizeQuizStep) {
      return IRSizeQuizWidget(
        step: step,
        onSelected: (index) => notifier.selectIRSizeAnswer(index),
        selectedIndex: challengeState.selectedIRSizeIndex,
        wasCorrect: wasCorrect, // Pass the status
      );
    }

    if (step is IROrientationQuizStep) {
      return IROrientationQuizWidget(
        step: step,
        onSelected: (index) => notifier.selectIROrientationAnswer(index),
        selectedIndex: challengeState.selectedIROrientationIndex,
        wasCorrect: wasCorrect, // Pass the status
      );
    }

    if (step is PatientPositionQuizStep) {
      return PatientPositionQuizWidget(
        step: step,
        onSelected: (index) => notifier.selectPatientPositionAnswer(index),
        selectedIndex: challengeState.selectedPatientPositionIndex,
        wasCorrect: wasCorrect, // Pass the status
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
          // Display Correct/Incorrect Icon *after* submission (if wasCorrect is not null)
          if (wasCorrect != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(
                wasCorrect
                    ? SolarIconsBold.checkCircle
                    : SolarIconsBold.closeCircle,
                color: wasCorrect ? Colors.green.shade600 : Colors.red.shade600,
                size: 30,
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
                      fit: BoxFit.cover, // Changed fit to contain
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
          // Disable button if an answer (correct/incorrect) has already been registered for this step
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(SolarIconsBold.checkCircle),
                label: const Text('Submit Collimation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  // Disable button if wasCorrect is not null (meaning already submitted)
                  disabledBackgroundColor: Colors.grey.shade400,
                ),
                // Disable onPressed if wasCorrect is not null
                onPressed:
                    wasCorrect == null
                        ? () => notifier.submitCollimation()
                        : null,
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

  // Helper function to get image path for collimation step
  String _getImagePathForCollimation(String bodyPartId, String projectionName) {
    // Standardize the projection name to match asset folder/file naming conventions
    final standardizedProjection = projectionName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('(', '')
        .replaceAll(')', '');
    final standardizedBodyPart = bodyPartId.toLowerCase();

    // Construct the expected path
    final imagePath =
        'assets/images/practice/$standardizedBodyPart/${standardizedBodyPart}_$standardizedProjection.webp';

    // TODO: Add error handling or a check to see if the file actually exists.
    // For now, assume the path constructed is correct based on naming conventions.
    print('Loading collimation image: $imagePath'); // Add print for debugging
    return imagePath;
  }
}
