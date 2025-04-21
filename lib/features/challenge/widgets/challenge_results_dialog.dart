import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../models/challenge.dart';
import '../state/challenge_state.dart';
import '../controllers/challenge_controller.dart';

class ChallengeResultsDialog extends ConsumerWidget {
  final Challenge challenge;

  const ChallengeResultsDialog({super.key, required this.challenge});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(challengeControllerProvider(challenge));
    final notifier = ref.read(challengeControllerProvider(challenge).notifier);

    final titleStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;
    final scoreStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
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
        statusText = 'Results';
        statusIcon = SolarIconsOutline.document;
        statusColor = AppTheme.textColor;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      contentPadding: const EdgeInsets.all(24.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(statusIcon, color: statusColor, size: 32),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              statusText,
              style: titleStyle?.copyWith(color: statusColor),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text(
            'Final Score',
            style: bodyStyle?.copyWith(
              color: AppTheme.textColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text('${state.score}', style: scoreStyle),
          const SizedBox(height: 24),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(
        bottom: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      actions: <Widget>[
        OutlinedButton.icon(
          icon: const Icon(SolarIconsOutline.closeCircle, size: 20),
          label: const Text('Close'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.secondaryColor,
            side: BorderSide(color: AppTheme.secondaryColor.withOpacity(0.5)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            if (GoRouter.of(context).canPop()) {
              context.pop();
            }
          },
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          icon: const Icon(SolarIconsOutline.refresh, size: 20),
          label: const Text('Retry'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            notifier.resetChallenge();
            notifier.startChallenge();
          },
        ),
      ],
    );
  }
}
