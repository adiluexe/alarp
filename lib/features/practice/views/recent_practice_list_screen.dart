import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/practice/widgets/recent_practice_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/data/repositories/practice_repository.dart'; // Import practice providers
import 'package:alarp/features/practice/models/practice_attempt.dart'; // Import model

// Convert to ConsumerWidget
class RecentPracticeListScreen extends ConsumerWidget {
  const RecentPracticeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider that fetches ALL attempts
    final practiceAttemptsAsync = ref.watch(allPracticeAttemptsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Recent Practice History'),
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          onPressed: () => context.pop(), // Go back to the previous screen
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: practiceAttemptsAsync.when(
        data: (attempts) {
          if (attempts.isEmpty) {
            return const Center(child: Text('No practice history yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: attempts.length,
            itemBuilder: (context, index) {
              final attempt = attempts[index];
              return RecentPracticeItem(
                attempt: attempt, // Pass the full attempt object
                // Add onTap later if needed to go to specific practice details
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error loading practice history: $error'),
              ),
            ),
      ),
    );
  }
}
