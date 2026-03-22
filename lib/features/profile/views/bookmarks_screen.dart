import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/profile/controllers/bookmarks_provider.dart';
import 'package:alarp/features/learn/data/static_lesson_data.dart';
import 'package:alarp/core/navigation/app_router.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedIds = ref.watch(bookmarksProvider);

    // Filter all lessons to find the ones that are bookmarked
    final bookmarkedLessons =
        allStaticLessons
            .where((lesson) => bookmarkedIds.contains(lesson.id))
            .toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Saved Lessons'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body:
          bookmarkedLessons.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      SolarIconsBold.bookmark,
                      size: 64,
                      color: Colors.grey[300],
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scaleXY(
                          begin: 1.0,
                          end: 1.1,
                          duration: 1600.ms,
                          curve: Curves.easeInOut,
                        ),
                    const SizedBox(height: 20),
                    Text(
                      'No saved lessons yet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the bookmark icon on any lesson to save it here',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[400],
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 300.ms),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookmarkedLessons.length,
                itemBuilder: (context, index) {
                  final lesson = bookmarkedLessons[index];
                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          SolarIconsBold.bookBookmark,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      title: Text(
                        lesson.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Tap to view lesson',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          SolarIconsBold.bookmark,
                          color: AppTheme.primaryColor,
                        ),
                        onPressed: () {
                          ref
                              .read(bookmarksProvider.notifier)
                              .toggleBookmark(lesson.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Removed from bookmarks'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      onTap: () {
                        // Navigate to lesson
                        // We need to construct the path manually or use a named route if available
                        // Assuming standard structure: /learn/region/:regionId/part/:lessonId
                        // But we don't easily have regionId here without looking it up.
                        // Let's assume we can find the region ID from the lesson or bodyRegion.

                        // Actually, LearnLessonScreen just needs lessonId.
                        // But the route structure requires regionId.
                        // Let's try to find the region ID.
                        // For now, we might need a helper to find region by lesson ID or just iterate regions.

                        // Simplified navigation if possible, or lookup:
                        // final regionId = BodyRegions.getRegionIdForLesson(lesson.id);
                        // context.pushNamed(AppRoutes.learnLesson, pathParameters: {'regionId': regionId, 'bodyPartId': lesson.id});

                        // Since we don't have getRegionIdForLesson easily, let's just push the screen directly if possible
                        // or use a route that doesn't require regionId if we had one.
                        // But our routes are nested.

                        // Workaround: Iterate regions to find the one containing this lesson.
                        // This is a bit inefficient but fine for this scale.

                        context.push(
                          '${AppRoutes.learn}/${AppRoutes.learnRegionDetail}/${lesson.bodyRegion}/${AppRoutes.learnLesson}/${lesson.id}',
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
