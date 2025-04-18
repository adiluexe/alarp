import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/navigation/app_router.dart'; // Import AppRoutes
import '../../../core/theme/app_theme.dart';
import '../models/challenge.dart';

// Provider to easily access the challenge data on this screen
final currentChallengeProvider = Provider<Challenge>((ref) {
  // This will be overridden in the GoRoute builder
  throw UnimplementedError();
});

class ChallengeStartScreen extends ConsumerWidget {
  final String challengeId;
  const ChallengeStartScreen({super.key, required this.challengeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the specific challenge using the overridden provider
    final challenge = ref.watch(currentChallengeProvider);

    // Define the gradient (matching the one from challenge_screen.dart)
    final Gradient? appBarGradient =
        challenge.isTodaysChallenge
            ? LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.8),
                AppTheme.accentColor.withOpacity(0.6),
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
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Challenge Details',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: 'Chillax',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildDetailRow(
              context,
              icon: SolarIconsOutline.notebook,
              label: 'Topic',
              value: challenge.description,
            ),
            _buildDetailRow(
              context,
              icon: SolarIconsOutline.chartSquare,
              label: 'Difficulty',
              value: challenge.difficulty,
            ),
            _buildDetailRow(
              context,
              icon: SolarIconsOutline.clockCircle,
              label: 'Time Limit',
              value:
                  '${challenge.timeLimit.inMinutes}:${(challenge.timeLimit.inSeconds % 60).toString().padLeft(2, '0')}',
            ),
            _buildDetailRow(
              context,
              icon: SolarIconsOutline.rulerPen, // Example icon for steps
              label: 'Steps',
              value: '${challenge.steps.length} step(s)',
            ),
            const Spacer(), // Push button to bottom
            ElevatedButton.icon(
              icon: const Icon(SolarIconsBold.play),
              label: const Text('Start Challenge'),
              style: ElevatedButton.styleFrom(
                // Style button based on whether it's today's challenge or not
                backgroundColor:
                    appBarGradient != null
                        ? AppTheme
                            .primaryColor // Use solid color if AppBar has gradient
                        : (challenge.backgroundColor ?? AppTheme.primaryColor),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // Navigate to the active challenge screen, passing the ID
                context.push(AppRoutes.challengeActive(challengeId));
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.textColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
