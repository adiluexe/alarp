import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:solar_icons/solar_icons.dart'; // Import Solar Icons
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/practice/models/body_region.dart'; // Assuming models are shared or moved to core
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the actual BodyRegions data if available
    final regions = BodyRegions.allRegions;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Learning Path',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontFamily: 'Chillax',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Study radiographic positioning by body regions',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        // Use withAlpha for opacity
                        color: AppTheme.textColor.withAlpha(
                          (255 * 0.7).round(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Body regions list (Changed from Grid to List)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                // Use map to generate cards from regions list
                delegate: SliverChildBuilderDelegate((context, index) {
                  final region = regions[index];
                  // Add padding between list items
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildBodyRegionCard(
                      context,
                      region: region,
                      // Example progress data (replace with actual data later)
                      completedPositions: 0,
                    ),
                  );
                }, childCount: regions.length),
              ),
            ),

            // Bottom space
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  // Update card builder to include description and reduce padding
  Widget _buildBodyRegionCard(
    BuildContext context, {
    required BodyRegion region,
    required int completedPositions, // Keep progress separate for now
  }) {
    final progress =
        region.positionCount > 0
            ? completedPositions / region.positionCount
            : 0.0;
    // Use white text for contrast on solid color
    const Color contentColor = Colors.white;
    final Color secondaryContentColor = contentColor.withAlpha(
      (255 * 0.8).round(),
    );
    final Color tertiaryContentColor = contentColor.withAlpha(
      (255 * 0.7).round(), // Slightly more transparent for description
    );

    return InkWell(
      onTap: () {
        // Navigate using GoRouter with the region's ID
        context.go(
          // Corrected: Use AppRoutes.learnRegionDetail constant
          '${AppRoutes.learn}/${AppRoutes.learnRegionDetail.replaceFirst(':regionId', region.id)}',
        );
      },
      borderRadius: BorderRadius.circular(20), // Match practice card radius
      child: Container(
        // Reduce vertical padding slightly
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          // Use solid background color
          color: region.backgroundColor,
          borderRadius: BorderRadius.circular(20), // Match practice card radius
          boxShadow: [
            BoxShadow(
              // Use withAlpha for opacity
              color: region.backgroundColor.withAlpha((255 * 0.4).round()),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Emoji with semi-transparent white background
                Container(
                  width: 48, // Match practice card size
                  height: 48,
                  decoration: BoxDecoration(
                    // Use withAlpha for opacity
                    color: Colors.white.withAlpha((255 * 0.2).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      region.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const Spacer(),
                // Use altArrowRight icon
                Icon(
                  SolarIconsOutline.altArrowRight,
                  color: secondaryContentColor,
                  size: 20,
                ),
              ],
            ),
            // Reduce space slightly
            const SizedBox(height: 12),
            // Title from region data
            Text(
              region.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontFamily: 'Chillax',
                color: contentColor, // Use white text
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Add Description
            const SizedBox(height: 4),
            Text(
              'Learn positioning for the ${region.title.toLowerCase()}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: tertiaryContentColor, // Use tertiary color
              ),
              maxLines: 2, // Allow two lines for description
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8), // Space before progress info
            // Positions count from region data
            Text(
              '$completedPositions of ${region.positionCount} topics learned', // Adjusted text
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: secondaryContentColor, // Use slightly transparent white
              ),
            ),
            const SizedBox(height: 8), // Reduced space before progress bar
            // Progress bar
            LinearProgressIndicator(
              value: progress,
              // Use semi-transparent white for background
              backgroundColor: Colors.white.withAlpha((255 * 0.2).round()),
              // Use solid white for value color
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              borderRadius: BorderRadius.circular(4),
              minHeight: 6,
            ),
            // No extra bottom space needed here as Padding is used in parent list
          ],
        ),
      ),
    );
  }
}
