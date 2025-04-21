import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/challenge/models/challenge_attempt.dart';
import 'package:alarp/features/profile/controllers/challenge_history_provider.dart';
import 'package:solar_icons/solar_icons.dart'; // Import icons
import 'package:go_router/go_router.dart';

class ChallengeHistoryScreen extends ConsumerWidget {
  const ChallengeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(challengeHistoryProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge History'),
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          onPressed: () => context.pop(),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withAlpha((0.1 * 255).round()),
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(challengeHistoryProvider.future),
        color: AppTheme.primaryColor,
        child: historyAsync.when(
          data: (history) {
            if (history.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      SolarIconsOutline.history,
                      size: 60,
                      color: AppTheme.textColor.withAlpha((0.5 * 255).round()),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No challenge attempts found yet!',
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textColor.withAlpha(
                          (0.7 * 255).round(),
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete some challenges to see your history here.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textColor.withAlpha(
                          (0.5 * 255).round(),
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final attempt = history[index];
                return _buildHistoryCard(context, attempt);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        SolarIconsOutline.dangerTriangle,
                        size: 60,
                        color: colorScheme.error.withAlpha((0.7 * 255).round()),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Oops! Could not load history.',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$error',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppTheme.textColor.withAlpha(
                            (0.6 * 255).round(),
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, ChallengeAttempt attempt) {
    final textTheme = Theme.of(context).textTheme;
    final formattedDate = DateFormat.yMMMd().add_jm().format(
      attempt.completedAt.toLocal(),
    );
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primaryColor.withAlpha(
                (0.12 * 255).round(),
              ),
              radius: 26,
              child: Icon(
                SolarIconsOutline.cupStar,
                color: AppTheme.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attempt.challengeTitle.isNotEmpty
                        ? attempt.challengeTitle
                        : 'Challenge',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Chillax',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppTheme.textColor.withAlpha((0.7 * 255).round()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${attempt.score} pts',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
