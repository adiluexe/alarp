import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/practice/models/body_region.dart'; // Assuming models are shared
import 'package:alarp/features/practice/models/body_part.dart'; // Assuming models are shared
import 'package:alarp/features/practice/widgets/body_part_card.dart'; // Reusing practice card for now
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes

// Provider to get the region data (replace with actual data fetching later)
final learnRegionProvider = Provider.family<BodyRegion, String>((
  ref,
  regionId,
) {
  // For now, use the static method. Later, this could fetch from a repository.
  return BodyRegions.getRegionById(regionId);
});

class LearnRegionDetailScreen extends ConsumerWidget {
  final String regionId;

  const LearnRegionDetailScreen({Key? key, required this.regionId})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the region data
    final region = ref.watch(learnRegionProvider(regionId));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(region.title),
        backgroundColor: region.backgroundColor, // Use region color for AppBar
        foregroundColor: Colors.white, // Ensure text/icons are visible
        elevation: 1,
      ),
      body: CustomScrollView(
        slivers: [
          // Header section (optional, could be simpler than practice)
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: region.backgroundColor.withOpacity(
                0.1,
              ), // Subtle background
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(region.emoji, style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Learn: ${region.title}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Chillax',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Select a body part to view the guide.',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Body parts list
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final bodyPart = region.bodyParts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  // Using BodyPartCard from practice for now, customize later if needed
                  child: BodyPartCard(
                    bodyPart: bodyPart,
                    onTap: () {
                      // Navigate to LearnLessonScreen
                      final path = '${AppRoutes.learn}/${AppRoutes.learnLesson}'
                          .replaceFirst(':regionId', regionId)
                          .replaceFirst(':bodyPartId', bodyPart.id);
                      context.go(path);
                    },
                    // Optional: Add different styling/info for learn context
                    // e.g., show number of steps instead of projections
                  ),
                );
              }, childCount: region.bodyParts.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
