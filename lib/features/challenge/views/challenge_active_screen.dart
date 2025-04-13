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
import '../../practice/widgets/collimation_painter.dart';
import '../../practice/widgets/collimation_controls_widget.dart';
import '../../practice/models/collimation_state.dart';
import '../../practice/models/body_part.dart'; // Import BodyPart
import '../../practice/models/body_region.dart'; // Import BodyRegions
import '../../practice/controllers/collimation_controller.dart'; // Ensure CollimationParams is accessible

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
    // Start the challenge when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final challenge = ref.read(activeChallengeProvider);
      ref
          .read(challengeControllerProvider(challenge).notifier)
          .startChallenge();
    });
  }

  @override
  Widget build(BuildContext context) {
    final challenge = ref.watch(activeChallengeProvider);
    final challengeState = ref.watch(challengeControllerProvider(challenge));
    final challengeNotifier = ref.read(
      challengeControllerProvider(challenge).notifier,
    );
    final bgColor = challenge.backgroundColor ?? AppTheme.primaryColor;

    // Listen for status changes to show results dialog
    ref.listen<ChallengeState>(challengeControllerProvider(challenge), (
      prev,
      next,
    ) {
      // Check if build_runner generated the state correctly
      // If status is still causing errors, ensure build_runner ran successfully
      if (prev?.status != next.status) {
        if (next.status == ChallengeStatus.completedSuccess ||
            next.status == ChallengeStatus.completedFailureTime ||
            next.status == ChallengeStatus.completedFailureIncorrect) {
          _showResultDialog(context, next.status, challengeNotifier);
        }
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(challenge.title),
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
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
                  // Replace deprecated withOpacity
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

    if (step is PositioningSelectionStep) {
      return PositioningSelectionWidget(
        step: step,
        onSelected: (index) => notifier.selectPositioningAnswer(index),
        selectedIndex: challengeState.selectedPositioningIndex,
      );
    }

    if (step is CollimationStep) {
      // Use practice screen's layout structure for collimation
      final colState = ref.watch(collimationStateProvider);
      // Fetch the body part image (similar to practice screen)
      final bodyPart = _findBodyPart(
        challengeState
            .challenge
            .regionId, // Use regionId from challenge in state
        step.bodyPartId,
      );
      final imageAsset =
          bodyPart?.imageAsset ??
          _placeholderImage; // Use placeholder as fallback

      // Create params needed for controls widget
      final params = (
        bodyPartId: step.bodyPartId,
        projectionName: step.projectionName,
      );

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
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
                        imageAsset, // Use the potentially placeholder path
                        fit: BoxFit.contain,
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
                    ],
                  ),
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
    return const Center(child: Text('Unknown challenge step'));
  }

  // Helper to format duration (MM:SS)
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // Show result dialog
  void _showResultDialog(
    BuildContext context,
    ChallengeStatus status,
    ChallengeController notifier,
  ) {
    String title;
    String message;
    IconData icon;
    Color color;

    switch (status) {
      case ChallengeStatus.completedSuccess:
        title = 'Challenge Complete!';
        message = 'Great job! You successfully completed the challenge.';
        icon = SolarIconsBold.checkCircle;
        color = Colors.green;
        break;
      case ChallengeStatus.completedFailureTime:
        title = 'Time\'s Up!';
        message = 'You ran out of time for this challenge.';
        icon = SolarIconsBold.alarmTurnOff;
        color = Colors.orange;
        break;
      case ChallengeStatus.completedFailureIncorrect:
        title = 'Incorrect';
        message = 'Your selection or collimation was incorrect.';
        icon = SolarIconsBold.closeCircle;
        color = Colors.red;
        break;
      default:
        return; // Don't show dialog for other statuses
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder:
          (context) => AlertDialog(
            title: Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 48),
                const SizedBox(height: 16),
                Text(message, textAlign: TextAlign.center),
                // TODO: Add score/details later
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  context.pop(); // Go back from active challenge screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  // Temporary helper to find body part - replace later
  BodyPart? _findBodyPart(String regionId, String bodyPartId) {
    try {
      // BodyRegions should now be available via import
      final region = BodyRegions.getRegionById(regionId);
      return region.bodyParts.firstWhere((part) => part.id == bodyPartId);
    } catch (e) {
      print(
        'Error finding body part: regionId=$regionId, bodyPartId=$bodyPartId, error=$e',
      ); // Add logging
      return null;
    }
  }
}

// Define placeholder path globally or import if defined elsewhere
const String _placeholderImage = 'assets/images/alarp_icon.png';
