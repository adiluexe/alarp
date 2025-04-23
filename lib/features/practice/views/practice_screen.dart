import 'package:flutter/material.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/features/practice/widgets/recent_practice_item.dart';
import 'package:alarp/features/practice/widgets/region_carousel_card.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:alarp/data/repositories/practice_repository.dart'; // Import Practice Repository
import 'package:alarp/features/practice/models/practice_attempt.dart'; // Import PracticeAttempt

import 'package:alarp/features/practice/models/body_region.dart'; // Import BodyRegions

// Convert to ConsumerWidget
class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the recent practice attempts provider
    final recentAttemptsAsync = ref.watch(recentPracticeAttemptsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Practice Lab',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontFamily: 'Chillax',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hands-on radiographic positioning practice',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Recent practice section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recently Practiced',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontFamily: 'Chillax',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton.icon(
                          // Use push instead of go to allow popping back
                          onPressed:
                              () => context.push(AppRoutes.recentPracticeList),
                          icon: const Icon(
                            SolarIconsOutline.clockCircle,
                            size: 18,
                          ),
                          label: const Text('View All'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Use AsyncValue.when to handle loading/error/data states
                    recentAttemptsAsync.when(
                      data: (attempts) {
                        if (attempts.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text('No recent practice sessions found.'),
                            ),
                          );
                        }
                        // Display max 2 recent items
                        return Column(
                          children:
                              attempts
                                  .take(2)
                                  .map(
                                    (attempt) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: RecentPracticeItem(
                                        attempt: attempt,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        );
                      },
                      loading:
                          () => const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      error:
                          (error, stack) => Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                              ),
                              child: Text(
                                'Error loading recent practice: $error',
                              ),
                            ),
                          ),
                    ),
                    const SizedBox(height: 24),
                    Container(height: 1, color: Colors.grey.withOpacity(0.2)),
                    const SizedBox(height: 24),
                    Text(
                      'Select Body Region',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: 'Chillax',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose a region to practice positioning techniques',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Body regions horizontal carousel
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                // Use ListView.builder for dynamic data
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: BodyRegions.allRegions.length,
                  itemBuilder: (context, index) {
                    final region = BodyRegions.allRegions[index];
                    return RegionCarouselCard(
                      regionId: region.id, // Pass the actual ID
                      title: region.title,
                      emoji: region.emoji,
                      positionCount: region.positionCount,
                      backgroundColor: region.backgroundColor,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
