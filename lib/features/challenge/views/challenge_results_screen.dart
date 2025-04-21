import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/challenge_controller.dart';
import '../models/challenge.dart'; // Import Challenge
import '../models/step_result.dart';
import '../state/challenge_state.dart';
import 'challenge_active_screen.dart'; // Import activeChallengeProvider

class ChallengeResultsScreen extends ConsumerWidget {
  const ChallengeResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the specific challenge for context (title, etc.)
    final challenge = ref.watch(activeChallengeProvider);
    // Read the final state of the controller for this challenge
    final challengeState = ref.watch(challengeControllerProvider(challenge));

    final theme = Theme.of(context);
    final results = challengeState.stepResults;
    final totalSteps = challenge.steps.length;
    final correctSteps = results.where((r) => r.isCorrect).length;
    final accuracy = totalSteps > 0 ? (correctSteps / totalSteps * 100) : 0.0;

    String title;
    String message;
    IconData icon;
    Color color;
    Color backgroundColor;

    switch (challengeState.status) {
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
        // Should ideally not reach here if navigation is correct
        title = 'Results';
        message = 'Challenge status unknown.';
        icon = SolarIconsOutline.infoCircle;
        color = Colors.grey.shade700;
        backgroundColor = Colors.grey.shade100;
    }

    return Scaffold(
      backgroundColor: backgroundColor, // Use status-based background
      appBar: AppBar(
        title: Text(challenge.title),
        backgroundColor: color, // Use status-based color
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: ListView(
        // Use ListView for potentially long results
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Header Section ---
          Center(
            child: Column(
              children: [
                Icon(icon, color: color, size: 60),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Chillax',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // --- Summary Stats ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                context,
                label: 'Final Score',
                value: challengeState.score.toString(),
                icon: SolarIconsOutline.cupStar,
                color: color,
              ),
              _buildStatCard(
                context,
                label: 'Accuracy',
                value: '${accuracy.toStringAsFixed(0)}%',
                icon: SolarIconsOutline.target,
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // --- Step Breakdown ---
          Text(
            'Step Results',
            style: theme.textTheme.titleLarge?.copyWith(
              fontFamily: 'Chillax',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (results.isEmpty)
            const Center(child: Text('No step results available.'))
          else
            ...results.map((result) => _buildStepResultTile(context, result)),

          const SizedBox(height: 32),

          // --- Action Button ---
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(SolarIconsOutline.home),
              label: const Text('Back to Challenges'),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                textStyle: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                // Navigate back to the main challenge screen
                context.go(AppRoutes.challenge);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color.withOpacity(0.8), size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStepResultTile(BuildContext context, StepResult result) {
    final theme = Theme.of(context);
    final isCorrect = result.isCorrect;
    final icon =
        isCorrect ? SolarIconsBold.checkCircle : SolarIconsBold.closeCircle;
    final color = isCorrect ? Colors.green.shade600 : Colors.red.shade600;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(
          result.stepInstruction ?? 'Step ${result.stepId}', // Show instruction
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Text(
          '+${result.scoreEarned}', // Show score earned for the step
          style: theme.textTheme.bodyLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Optional: Add subtitle for more details like accuracy if needed
        subtitle:
            result.accuracy != null
                ? Text(
                  'Collimation Accuracy: ${result.accuracy!.toStringAsFixed(1)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                )
                : null,
      ),
    );
  }
}
