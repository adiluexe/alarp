import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';

import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/challenge_controller.dart';
import '../models/challenge.dart';
import '../models/step_result.dart';
import '../state/challenge_state.dart';
import 'challenge_active_screen.dart';

class ChallengeResultsScreen extends ConsumerStatefulWidget {
  const ChallengeResultsScreen({super.key});

  @override
  ConsumerState<ChallengeResultsScreen> createState() =>
      _ChallengeResultsScreenState();
}

class _ChallengeResultsScreenState
    extends ConsumerState<ChallengeResultsScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _scoreAnimController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _scoreAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scoreAnimController.dispose();
    super.dispose();
  }

  void _triggerAnimations(bool isSuccess, int score) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scoreAnimation = Tween<double>(
        begin: 0,
        end: score.toDouble(),
      ).animate(CurvedAnimation(
        parent: _scoreAnimController,
        curve: Curves.easeOut,
      ));
      _scoreAnimController.forward();

      if (isSuccess) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) _confettiController.play();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final challenge = ref.watch(activeChallengeProvider);
    final challengeState = ref.watch(challengeControllerProvider(challenge));

    final theme = Theme.of(context);
    final results = challengeState.stepResults;
    final totalSteps = challenge.steps.length;
    final correctSteps = results.where((r) => r.isCorrect).length;
    final accuracy =
        totalSteps > 0 ? (correctSteps / totalSteps * 100) : 0.0;
    final isSuccess =
        challengeState.status == ChallengeStatus.completedSuccess;

    // Trigger animations once
    _triggerAnimations(isSuccess, challengeState.score);

    final Color headerColor =
        isSuccess ? const Color(0xFF2E7D32) : Colors.orange.shade700;
    final Color headerBg =
        isSuccess ? const Color(0xFFE8F5E9) : Colors.orange.shade50;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: pi / 2,
              numberOfParticles: 30,
              gravity: 0.2,
              emissionFrequency: 0.04,
              colors: const [
                AppTheme.primaryColor,
                AppTheme.accentColor,
                AppTheme.secondaryColor,
                Colors.amber,
                Colors.green,
              ],
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Hero header
                SliverToBoxAdapter(
                  child: _buildHeader(
                    context,
                    theme,
                    isSuccess,
                    headerColor,
                    headerBg,
                    challengeState,
                    accuracy,
                    challenge,
                  ),
                ),

                // Step results title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: Text(
                      'Step Breakdown',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontFamily: 'Chillax',
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
                  ),
                ),

                // Step results
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final result = results[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: _buildStepResultTile(context, theme, result),
                      )
                          .animate()
                          .fadeIn(
                            delay: Duration(milliseconds: 800 + index * 80),
                            duration: 350.ms,
                          )
                          .slideX(begin: 0.1, end: 0);
                    },
                    childCount: results.length,
                  ),
                ),

                // Action buttons
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(SolarIconsOutline.restart),
                            label: const Text('Try Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: headerColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              context.go(
                                AppRoutes.challengeStartRoute(challenge.id),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(SolarIconsOutline.home2),
                            label: const Text('Back to Challenges'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: headerColor,
                              side: BorderSide(color: headerColor),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () => context.go(AppRoutes.challenge),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    bool isSuccess,
    Color headerColor,
    Color headerBg,
    dynamic challengeState,
    double accuracy,
    Challenge challenge,
  ) {
    final IconData icon = isSuccess
        ? SolarIconsBold.checkCircle
        : SolarIconsBold.alarmTurnOff;
    final String title =
        isSuccess ? 'Challenge Complete!' : "Time's Up!";
    final String message = isSuccess
        ? 'Great job! You nailed this challenge.'
        : 'You ran out of time. Keep practicing!';

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: headerBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: headerColor.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Icon
          Icon(icon, color: headerColor, size: 72)
              .animate()
              .scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: 500.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(duration: 300.ms),

          const SizedBox(height: 16),

          // Title
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: headerColor,
              fontFamily: 'Chillax',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

          const SizedBox(height: 6),

          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: headerColor.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

          const SizedBox(height: 24),

          // Score + Accuracy row
          Row(
            children: [
              Expanded(
                child: _buildAnimatedStat(
                  context,
                  theme,
                  label: 'Final Score',
                  icon: SolarIconsBold.cupStar,
                  color: headerColor,
                  value: challengeState.score,
                  suffix: ' pts',
                  delay: 500,
                ),
              ),
              Container(
                width: 1,
                height: 56,
                color: headerColor.withOpacity(0.2),
              ),
              Expanded(
                child: _buildAnimatedStat(
                  context,
                  theme,
                  label: 'Accuracy',
                  icon: SolarIconsBold.target,
                  color: headerColor,
                  value: accuracy.round(),
                  suffix: '%',
                  delay: 600,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
        ],
      ),
    );
  }

  Widget _buildAnimatedStat(
    BuildContext context,
    ThemeData theme, {
    required String label,
    required IconData icon,
    required Color color,
    required int value,
    required String suffix,
    required int delay,
  }) {
    return Column(
      children: [
        Icon(icon, color: color.withOpacity(0.7), size: 26),
        const SizedBox(height: 6),
        AnimatedBuilder(
          animation: _scoreAnimController,
          builder: (context, _) {
            final displayValue = (_scoreAnimController.isAnimating ||
                    _scoreAnimController.isCompleted)
                ? (value * _scoreAnimController.value).round()
                : value;
            return Text(
              '$displayValue$suffix',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Chillax',
              ),
            );
          },
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildStepResultTile(
    BuildContext context,
    ThemeData theme,
    StepResult result,
  ) {
    final isCorrect = result.isCorrect;
    final color =
        isCorrect ? const Color(0xFF2E7D32) : Colors.red.shade600;
    final bgColor =
        isCorrect ? const Color(0xFFE8F5E9) : Colors.red.shade50;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCorrect
                ? SolarIconsBold.checkCircle
                : SolarIconsBold.closeCircle,
            color: color,
            size: 22,
          ),
        ),
        title: Text(
          result.stepInstruction ?? 'Step ${result.stepId}',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        subtitle: result.accuracy != null
            ? Text(
                'Collimation: ${result.accuracy!.toStringAsFixed(1)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color.withOpacity(0.7),
                ),
              )
            : null,
        trailing: Text(
          '+${result.scoreEarned}',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            fontFamily: 'Chillax',
          ),
        ),
      ),
    );
  }
}
