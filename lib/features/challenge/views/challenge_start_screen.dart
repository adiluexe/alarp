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
    final challenge = ref.watch(currentChallengeProvider);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Define the gradient for the button
    const buttonGradient = LinearGradient(
      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Ready for the Challenge?',
                style: textTheme.headlineMedium?.copyWith(
                  fontFamily: 'Chillax',
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              Text(
                challenge.description,
                style: textTheme.titleSmall?.copyWith(
                  color: AppTheme.textColor.withOpacity(0.8),
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 2,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        context,
                        icon: SolarIconsOutline.chartSquare,
                        label: 'Difficulty',
                        value: challenge.difficulty,
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        icon: SolarIconsOutline.clockCircle,
                        label: 'Time Limit',
                        value:
                            '${challenge.timeLimit.inMinutes}:${(challenge.timeLimit.inSeconds % 60).toString().padLeft(2, '0')}',
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        icon: SolarIconsOutline.rulerPen,
                        label: 'Steps',
                        value: '${challenge.steps.length} step(s)',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Container(
                decoration: BoxDecoration(
                  gradient: buttonGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(SolarIconsBold.play, color: Colors.white),
                  label: Text(
                    'Start Challenge',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    context.push(AppRoutes.challengeActive(challengeId));
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 22),
          const SizedBox(width: 16),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textColor.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
