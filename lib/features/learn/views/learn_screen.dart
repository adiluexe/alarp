import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/practice/models/body_region.dart'; // Assuming models are shared or moved to core
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  // Helper function to get BodyRegion data (replace with provider later)
  BodyRegion _getRegionData(String title) {
    // This is temporary; ideally fetch from a provider based on title/id
    return BodyRegions.allRegions.firstWhere(
      (r) => r.title == title,
      orElse: () => BodyRegions.headAndNeck, // Default fallback
    );
  }

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
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Body regions grid using actual data
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                // Use map to generate cards from regions list
                delegate: SliverChildBuilderDelegate((context, index) {
                  final region = regions[index];
                  // Pass the actual region data to the card builder
                  return _buildBodyRegionCard(
                    context,
                    region: region,
                    // Example progress data (replace with actual data later)
                    completedPositions: 0,
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

  // Update card builder to accept BodyRegion and use its data
  Widget _buildBodyRegionCard(
    BuildContext context, {
    required BodyRegion region,
    required int completedPositions, // Keep progress separate for now
  }) {
    final progress =
        region.positionCount > 0
            ? completedPositions / region.positionCount
            : 0.0;

    return InkWell(
      onTap: () {
        // Navigate using GoRouter with the region's ID
        context.go(
          '${AppRoutes.learn}/${AppRoutes.learnRegionDetail.replaceFirst(':regionId', region.id)}',
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji with colored background using region color
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: region.backgroundColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(region.emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),

            const Spacer(),

            // Title from region data
            Text(
              region.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: 'Chillax',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Positions count from region data
            Text(
              '$completedPositions of ${region.positionCount} positions',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),

            // Progress bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: region.backgroundColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(region.backgroundColor),
              borderRadius: BorderRadius.circular(4),
              minHeight: 6,
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
