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
import '../widgets/ir_size_quiz_widget.dart';
import '../widgets/ir_orientation_quiz_widget.dart';
import '../widgets/patient_position_quiz_widget.dart';
import '../../practice/widgets/collimation_painter.dart';
import '../../practice/widgets/collimation_controls_widget.dart';
import '../../practice/models/collimation_state.dart';
import '../widgets/challenge_results_dialog.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate progress
    final totalSteps = challenge.steps.length;
    final currentStepIndex = challengeState.currentStepIndex;
    final progress = totalSteps > 0 ? (currentStepIndex + 1) / totalSteps : 0.0;

    // Gradient for Progress Indicator (can be same as AppBar or different)
    final progressGradient = LinearGradient(
      colors: [
        // Use vibrant colors for the progress bar itself
        Colors.lightBlueAccent.shade100,
        Colors.purpleAccent.shade100,
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    // Listen for status changes to SHOW the results dialog
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
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            return ChallengeResultsDialog(challenge: challenge);
          },
        );
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Make AppBar background transparent
        elevation: 0, // Remove shadow if desired
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(challenge.title),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          onPressed: () {
            final currentStatus =
                ref.read(challengeControllerProvider(challenge)).status;
            if (currentStatus == ChallengeStatus.inProgress) {
              showDialog(
                context: context,
                builder:
                    (ctx) => AlertDialog(
                      title: const Text('Exit Challenge?'),
                      content: const Text(
                        'Are you sure you want to exit the challenge? Your progress will be lost.',
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                        TextButton(
                          child: const Text('Exit'),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            context.pop();
                          },
                        ),
                      ],
                    ),
              );
            } else {
              context.pop();
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Consumer(
              builder: (context, ref, _) {
                final remainingTime = ref.watch(
                  challengeControllerProvider(
                    challenge,
                  ).select((s) => s.remainingTime),
                );
                return Row(
                  children: [
                    Icon(
                      SolarIconsOutline.clockCircle,
                      color: Colors.white.withAlpha((255 * 0.8).round()),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDuration(remainingTime),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: ShaderMask(
            shaderCallback:
                (bounds) => progressGradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
            child: LinearProgressIndicator(
              value: progress,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: colorScheme.primary.withOpacity(0.2),
              minHeight: 10.0,
            ),
          ),
        ),
      ),
      body: _buildStepWidget(
        context,
        challengeState,
        ref.read(challengeControllerProvider(challenge).notifier),
      ),
    );
  }

  Widget _buildStepWidget(
    BuildContext context,
    ChallengeState challengeState,
    ChallengeController notifier,
  ) {
    final step = challengeState.currentStep;
    final wasCorrect = challengeState.wasLastAnswerCorrect;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (challengeState.status == ChallengeStatus.completedSuccess ||
        challengeState.status == ChallengeStatus.completedFailureTime) {
      return const Center(child: CircularProgressIndicator());
    }

    if (challengeState.status != ChallengeStatus.inProgress || step == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (step is PositioningSelectionStep) {
      return PositioningSelectionWidget(
        step: step,
        onSelected: (index) => notifier.selectPositioningAnswer(index),
        selectedIndex: challengeState.selectedPositioningIndex,
        wasCorrect: wasCorrect,
      );
    }

    if (step is IRSizeQuizStep) {
      return IRSizeQuizWidget(
        step: step,
        onSelected: (index) => notifier.selectIRSizeAnswer(index),
        selectedIndex: challengeState.selectedIRSizeIndex,
        wasCorrect: wasCorrect,
      );
    }

    if (step is IROrientationQuizStep) {
      return IROrientationQuizWidget(
        step: step,
        onSelected: (index) => notifier.selectIROrientationAnswer(index),
        selectedIndex: challengeState.selectedIROrientationIndex,
        wasCorrect: wasCorrect,
      );
    }

    if (step is PatientPositionQuizStep) {
      return PatientPositionQuizWidget(
        step: step,
        onSelected: (index) => notifier.selectPatientPositionAnswer(index),
        selectedIndex: challengeState.selectedPatientPositionIndex,
        wasCorrect: wasCorrect,
      );
    }

    if (step is CollimationStep) {
      final colState = ref.watch(collimationStateProvider);
      final imageAsset = _getImagePathForCollimation(
        step.bodyPartId,
        step.projectionName,
      );
      final params = (
        bodyPartId: step.bodyPartId,
        projectionName: step.projectionName,
      );

      return Column(
        children: [
          if (step.instruction != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                step.instruction!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onBackground.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (wasCorrect != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Icon(
                wasCorrect
                    ? SolarIconsBold.checkCircle
                    : SolarIconsBold.closeCircle,
                color: wasCorrect ? Colors.green.shade600 : Colors.red.shade600,
                size: 30,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        imageAsset,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => const Center(
                              child: Icon(
                                SolarIconsOutline.galleryRemove,
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
                              angle: colState.angle,
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
          Expanded(child: CollimationControlsWidget(params: params)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(SolarIconsBold.checkCircle),
                label: const Text('Submit Collimation'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: theme.textTheme.labelLarge?.copyWith(fontSize: 16),
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey.shade400;
                    }
                    return colorScheme.primary;
                  }),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    colorScheme.onPrimary,
                  ),
                ),
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

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Unknown challenge step type: ${step.runtimeType}',
          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  String _getImagePathForCollimation(String bodyPartId, String projectionName) {
    final standardizedProjection = projectionName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('(', '')
        .replaceAll(')', '');
    final standardizedBodyPart = bodyPartId.toLowerCase();
    final imagePath =
        'assets/images/practice/$standardizedBodyPart/${standardizedBodyPart}_$standardizedProjection.webp';
    return imagePath;
  }
}
