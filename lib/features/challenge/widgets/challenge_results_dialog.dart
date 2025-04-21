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
    ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold);
    final bodyStyle = Theme.of(context).textTheme.bodyLarge;
    final scoreStyle = Theme.of(context).textTheme.displayMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: AppTheme.primaryColor,
    );

    String statusText;
    IconData statusIcon;
    Color statusColor;
    IconData prominentIcon;
    Color prominentIconColor;

    switch (state.status) {
      case ChallengeStatus.completedSuccess:
        statusText = 'Challenge Complete!';
        statusIcon = SolarIconsBold.medalStar;
        statusColor = Colors.green.shade600;
        prominentIcon = SolarIconsBold.cupStar;
        prominentIconColor = Colors.amber.shade700;
        break;
      case ChallengeStatus.completedFailureTime:
        statusText = 'Time\'s Up!';
        statusIcon = SolarIconsBold.alarmTurnOff;
        statusColor = Colors.orange.shade700;
        prominentIcon = SolarIconsBold.sadCircle;
        prominentIconColor = Colors.red.shade600;
        break;
      default:
        statusText = 'Results';
        statusIcon = SolarIconsOutline.document;
        statusColor = AppTheme.textColor;
        prominentIcon = SolarIconsOutline.document;
        prominentIconColor = AppTheme.textColor.withOpacity(0.5);
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      contentPadding: const EdgeInsets.all(32.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(statusIcon, color: statusColor, size: 28),
          const SizedBox(width: 10),
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
          const SizedBox(height: 24),
          Icon(prominentIcon, color: prominentIconColor, size: 80),
          const SizedBox(height: 24),
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
        bottom: 24.0,
        left: 24.0,
        right: 24.0,
      ),
      actions: <Widget>[
        OutlinedButton.icon(
          icon: const Icon(SolarIconsOutline.closeCircle, size: 20),
          label: const Text('Close'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.secondaryColor,
            side: BorderSide(color: AppTheme.secondaryColor.withOpacity(0.5)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            if (GoRouter.of(context).canPop()) {
              context.pop();
            }
          },
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          icon: const Icon(SolarIconsOutline.refresh, size: 20),
          label: const Text('Retry'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4,
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
