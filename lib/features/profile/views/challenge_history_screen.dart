import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/challenge/models/challenge_attempt.dart';
import 'package:alarp/features/profile/controllers/challenge_history_provider.dart';
import 'package:solar_icons/solar_icons.dart'; // Import icons

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
        backgroundColor: colorScheme.surface, // Use theme color
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      backgroundColor: colorScheme.surface, // Match background
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(challengeHistoryProvider.future),
        color: AppTheme.primaryColor, // Use primary color for indicator
        child: historyAsync.when(
          data: (history) {
            if (history.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      SolarIconsOutline.history, // Use a relevant icon
                      size: 60,
                      color: AppTheme.textColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No challenge attempts found yet!',
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete some challenges to see your history here.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final attempt = history[index];
                return _buildHistoryTile(context, attempt);
              },
              separatorBuilder:
                  (context, index) => Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    indent: 16,
                    endIndent: 16,
                  ),
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
                        color: colorScheme.error.withOpacity(0.7),
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
                        '$error', // Show the actual error message
                        style: textTheme.bodySmall?.copyWith(
                          color: AppTheme.textColor.withOpacity(0.6),
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

  Widget _buildHistoryTile(BuildContext context, ChallengeAttempt attempt) {
    final textTheme = Theme.of(context).textTheme;
    // Format the date nicely
    final formattedDate = DateFormat.yMMMd().add_jm().format(
      attempt.completedAt.toLocal(),
    );

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      leading: CircleAvatar(
        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
        child: Icon(
          SolarIconsOutline.cupStar, // Icon representing achievement/score
          color: AppTheme.primaryColor,
          size: 24,
        ),
      ),
      title: Text(
        // Use title directly if it's guaranteed non-nullable and check if empty
        attempt.challengeTitle.isNotEmpty
            ? attempt.challengeTitle
            : 'Challenge',
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        formattedDate,
        style: textTheme.bodySmall?.copyWith(
          color: AppTheme.textColor.withOpacity(0.7),
        ),
      ),
      trailing: Text(
        '${attempt.score} pts',
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
      // Optional: Add onTap to view details if needed later
      // onTap: () {
      //   // Navigate to a detail screen for this attempt?
      //   // You could pass attempt.id or the full attempt object
      // },
    );
  }
}
