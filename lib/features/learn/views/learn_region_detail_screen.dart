import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart'; // Import Solar Icons
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/practice/models/body_region.dart'; // Assuming models are shared
import 'package:alarp/features/practice/models/body_part.dart'; // Assuming models are shared
import 'package:alarp/features/practice/widgets/body_part_card.dart'; // Reusing practice card for now
import '../data/static_lesson_data.dart'; // Import the static data functions

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
        title: Text('Learn: ${region.title}'), // Add "Learn:" prefix
        backgroundColor: region.backgroundColor, // Use region color for AppBar
        foregroundColor: Colors.white, // Ensure text/icons are visible
        elevation: 0, // Match practice screen's elevation
        leading: IconButton(
          // Custom back button
          icon: const Icon(SolarIconsOutline.altArrowLeft), // Changed icon
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Header section replicating practice style
          SliverToBoxAdapter(child: _buildLearnRegionHeader(context, region)),

          // Body parts list
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              0,
            ), // Adjust top padding
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final bodyPart = region.bodyParts[index];
                // Check if a lesson exists for this body part ID
                final lessonExists =
                    getLessonFromStaticSource(bodyPart.id) != null;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: BodyPartCard(
                    bodyPart: bodyPart,
                    // Disable onTap if no lesson exists, or navigate differently
                    onTap:
                        lessonExists
                            ? () {
                              // Navigate relatively using the bodyPart.id
                              context.go('./part/${bodyPart.id}');
                            }
                            : null, // Disable tap if no lesson
                    // Optional: Add visual indication if lesson is unavailable
                    isDimmed: !lessonExists,
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

  // New header widget inspired by practice screen's header
  Widget _buildLearnRegionHeader(BuildContext context, BodyRegion region) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24), // Adjust padding
      decoration: BoxDecoration(
        color: region.backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Region info (Emoji and Title)
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    region.emoji,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${region.positionCount} potential topics', // Adjusted text
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Learn instructions box
          Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                // Add subtle shadow like practice
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: region.backgroundColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    SolarIconsOutline.notebook, // Changed icon
                    color: region.backgroundColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Select a body part below to view the learning guide.', // Adjusted text
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Extend BodyPartCard slightly to handle dimming (optional)
class BodyPartCard extends StatelessWidget {
  final BodyPart bodyPart;
  final VoidCallback? onTap; // Make onTap nullable
  final bool isDimmed; // Add flag

  const BodyPartCard({
    Key? key,
    required this.bodyPart,
    this.onTap, // Updated
    this.isDimmed = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Opacity widget to dim if needed
    return Opacity(
      opacity: isDimmed ? 0.5 : 1.0,
      child: InkWell(
        // Only allow tap if onTap is not null
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(
            bottom: 0,
          ), // Removed margin as Padding is used in parent
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
          child: Row(
            children: [
              // Image section
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    bodyPart.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback for missing images
                      return Container(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        child: Center(
                          child: Icon(
                            SolarIconsOutline.bones,
                            color: AppTheme.primaryColor,
                            size: 32,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Content section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bodyPart.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bodyPart.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textColor.withOpacity(0.7),
                        ),
                        maxLines: 2, // Limit description lines
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Hide projections chips if dimmed (or show different info)
                      if (!isDimmed)
                        Wrap(
                          spacing: 6, // Reduced spacing
                          runSpacing: 4,
                          children:
                              bodyPart.projections.map((projection) {
                                return Chip(
                                  label: Text(
                                    projection,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall?.copyWith(
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                  backgroundColor: AppTheme.primaryColor
                                      .withOpacity(0.1),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 0,
                                  ), // Adjust padding
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                );
                              }).toList(),
                        )
                      else // Show alternative text if dimmed
                        Text(
                          'Guide coming soon',
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Arrow icon (only show if tappable)
              if (onTap != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey[400],
                    size: 24,
                  ),
                )
              else // Add padding placeholder if not tappable
                const SizedBox(width: 16 + 24), // Match icon padding + size
            ],
          ),
        ),
      ),
    );
  }
}
