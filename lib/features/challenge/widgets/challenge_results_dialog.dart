import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../models/challenge.dart';
import '../state/challenge_state.dart';
import '../controllers/challenge_controller.dart';
import '../models/step_result.dart'; // Import StepResult

class ChallengeResultsDialog extends ConsumerWidget {
  final Challenge challenge;

  const ChallengeResultsDialog({super.key, required this.challenge});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the final state of the completed challenge
    final state = ref.watch(challengeControllerProvider(challenge));
    final notifier = ref.read(challengeControllerProvider(challenge).notifier);

    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: AppTheme.primaryColor,
    );
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;
    final scoreStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color:
          state.status == ChallengeStatus.completedSuccess
              ? Colors.green.shade700
              : Colors.orange.shade800,
    );

    String statusText;
    IconData statusIcon;
    Color statusColor;

    switch (state.status) {
      case ChallengeStatus.completedSuccess:
        statusText = 'Challenge Complete!';
        statusIcon = SolarIconsBold.medalStar;
        statusColor = Colors.green.shade600;
        break;
      case ChallengeStatus.completedFailureTime:
        statusText = 'Time\'s Up!';
        statusIcon = SolarIconsBold.alarmTurnOff;
        statusColor = Colors.orange.shade700;
        break;
      default:
        // Should not happen if dialog is shown correctly
        statusText = 'Results';
        statusIcon = SolarIconsOutline.document;
        statusColor = AppTheme.textColor;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      title: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusText,
              style: titleStyle?.copyWith(color: statusColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        // Make content scrollable if results are long
        child: Column(
          mainAxisSize: MainAxisSize.min, // Take minimum space needed
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text('Score: ${state.score}', style: scoreStyle)),
            const SizedBox(height: 16),
            Text(
              'Breakdown:',
              style: bodyStyle?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            if (state.stepResults.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('No steps were completed.', style: bodyStyle),
              )
            else
              // Replace ListView.builder with a Column for simplicity in Dialog
              Column(
                mainAxisSize:
                    MainAxisSize.min, // Ensure Column doesn't expand infinitely
                children:
                    state.stepResults.asMap().entries.map((entry) {
                      final index = entry.key;
                      final result = entry.value;
                      return _buildResultItem(context, index + 1, result);
                    }).toList(),
              ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton.icon(
          icon: const Icon(SolarIconsOutline.closeCircle),
          label: const Text('Close'),
          style: TextButton.styleFrom(foregroundColor: AppTheme.secondaryColor),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            // Check if the active screen is still mounted before popping it
            if (GoRouter.of(context).canPop()) {
              context.pop(); // Go back from the ChallengeActiveScreen
            }
          },
        ),
        ElevatedButton.icon(
          icon: const Icon(SolarIconsOutline.refresh),
          label: const Text('Retry'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            // Reset and start the challenge again using the notifier
            notifier.resetChallenge();
            notifier.startChallenge();
          },
        ),
      ],
    );
  }

  Widget _buildResultItem(
    BuildContext context,
    int stepNumber,
    StepResult result,
  ) {
    final textStyle = Theme.of(context).textTheme.bodySmall;
    final correctColor = Colors.green.shade700;
    final incorrectColor = Colors.red.shade700;

    // Use stepInstruction ?? 'Step Description Unavailable' as fallback
    final description =
        result.stepInstruction ?? 'Step Description Unavailable';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            result.isCorrect
                ? SolarIconsBold.checkCircle
                : SolarIconsBold.closeCircle,
            color: result.isCorrect ? correctColor : incorrectColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Step $stepNumber: $description', // Use the description variable
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            result.isCorrect
                ? '+${result.scoreEarned}'
                : '+0', // Use scoreEarned
            style: textStyle?.copyWith(
              fontWeight: FontWeight.bold,
              color: result.isCorrect ? correctColor : incorrectColor,
            ),
          ),
        ],
      ),
    );
  }
}
