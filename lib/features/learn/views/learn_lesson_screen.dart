import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/practice/models/body_region.dart'; // Assuming models are shared
import 'package:alarp/features/practice/models/body_part.dart'; // Assuming models are shared

// Provider to get the specific body part data (replace with actual data fetching later)
final learnBodyPartProvider =
    Provider.family<BodyPart?, ({String regionId, String bodyPartId})>((
      ref,
      ids,
    ) {
      final region = BodyRegions.getRegionById(ids.regionId);
      try {
        return region.bodyParts.firstWhere((part) => part.id == ids.bodyPartId);
      } catch (e) {
        return null; // Handle case where body part isn't found
      }
    });

class LearnLessonScreen extends ConsumerWidget {
  final String regionId;
  final String bodyPartId;
  // final String? projectionId; // Optional: Add later if lessons are projection-specific

  const LearnLessonScreen({
    Key? key,
    required this.regionId,
    required this.bodyPartId,
    // this.projectionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the body part data
    final bodyPart = ref.watch(
      learnBodyPartProvider((regionId: regionId, bodyPartId: bodyPartId)),
    );

    if (bodyPart == null) {
      // Handle error case where body part data couldn't be loaded
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Could not load lesson data.')),
      );
    }

    // Placeholder content - Replace with actual lesson structure
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(bodyPart.title),
        // Consider using a less prominent color than the region color here
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textColor,
        elevation: 1,
      ),
      body: ListView(
        // Use ListView for potentially long content
        padding: const EdgeInsets.all(16.0),
        children: [
          // Lesson Header
          Text(
            'Guide: ${bodyPart.title}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontFamily: 'Chillax',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bodyPart.description, // Show description from BodyPart model
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textColor.withOpacity(0.7),
            ),
          ),
          const Divider(height: 32),

          // Placeholder for Lesson Content
          Text(
            'Lesson Content Placeholder',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          const Text(
            'This section will contain the step-by-step guide, images, '
            'key considerations, evaluation criteria, and potentially a '
            'non-interactive 3D preview for the selected body part and projection.\n\n'
            'For now, this is just a placeholder.',
          ),
          // Add more placeholder sections as needed
          // e.g., Image placeholder, Steps placeholder
          const SizedBox(height: 24),
          Placeholder(
            fallbackHeight: 200,
            color: AppTheme.primaryColor.withOpacity(0.1),
          ),
          const SizedBox(height: 24),
          const Text('Step 1: ...'),
          const SizedBox(height: 8),
          const Text('Step 2: ...'),
          const SizedBox(height: 8),
          const Text('Step 3: ...'),
        ],
      ),
    );
  }
}
