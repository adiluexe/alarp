import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart'; // Import go_router for context.pop()
import 'package:solar_icons/solar_icons.dart'; // Import icons
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/learn/controllers/learn_providers.dart';
import 'package:alarp/features/learn/models/lesson.dart';
import 'package:alarp/features/learn/widgets/learn_model_viewer.dart';
// Import the region provider and model to get the color
import 'package:alarp/features/learn/views/learn_region_detail_screen.dart'
    show learnRegionProvider;
import 'package:alarp/features/practice/models/body_region.dart';

class LearnLessonScreen extends ConsumerWidget {
  final String lessonId;

  const LearnLessonScreen({Key? key, required this.lessonId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Lesson? lesson = ref.watch(lessonDetailProvider(lessonId));

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Lesson data not found.')),
      );
    }

    // Fetch the region data based on the lesson's bodyRegion string
    // Note: This assumes lesson.bodyRegion matches a valid regionId used by learnRegionProvider
    // Add error handling or default color if region lookup fails
    final BodyRegion region = ref.watch(learnRegionProvider(lesson.bodyRegion));

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(lesson.title),
        // Use the region's background color
        backgroundColor: region.backgroundColor,
        // Use white for text/icons on colored background
        foregroundColor: Colors.white,
        elevation: 0, // Match region detail screen elevation
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          // Use context.pop() for GoRouter navigation
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Display 3D Model Viewer First (if available)
          if (lesson.modelPath != null)
            _buildMediaContainer(
              context,
              child: LearnModelViewer(src: lesson.modelPath!),
              // Make model viewer larger, adjust aspect ratio as needed (e.g., 1:1 or 4:3)
              aspectRatio: 1.0, // Changed aspect ratio
            ),

          // 2. Display Markdown Content
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: MarkdownBody(
              data: lesson.content,
              styleSheet: _buildMarkdownStyleSheet(theme, textTheme),
            ),
          ),

          // 3. Display Image Last (if available)
          if (lesson.imageUrl != null)
            Padding(
              // Add some space before the image if markdown is present
              padding: const EdgeInsets.only(top: 24.0),
              child: _buildMediaContainer(
                context,
                child: Image.asset(
                  lesson.imageUrl!,
                  fit: BoxFit.contain, // Use contain to see the whole image
                  errorBuilder:
                      (context, error, stackTrace) => const Center(
                        child: Icon(Icons.broken_image, size: 48),
                      ),
                ),
                // Keep image aspect ratio or adjust as needed
                aspectRatio: 16 / 9,
              ),
            ),

          const SizedBox(height: 24), // Padding at the bottom
        ],
      ),
    );
  }

  // Helper widget for consistent media container styling
  Widget _buildMediaContainer(
    BuildContext context, {
    required Widget child,
    double aspectRatio = 16 / 9,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            // Use a slightly lighter background for the container
            color: Colors.grey[100], // Changed background color
            child: child,
          ),
        ),
      ),
    );
  }

  // Helper function to build the MarkdownStyleSheet using the theme
  MarkdownStyleSheet _buildMarkdownStyleSheet(
    ThemeData theme,
    TextTheme textTheme,
  ) {
    // Add blockSpacing for vertical space between elements
    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      blockSpacing: 16.0, // Adjust this value for desired vertical spacing
      h1: textTheme.headlineMedium?.copyWith(
        fontFamily: 'Chillax',
        fontWeight: FontWeight.w700,
        color: AppTheme.primaryColor, // Use theme color
        height: 1.4,
      ),
      h2: textTheme.headlineSmall?.copyWith(
        fontFamily: 'Chillax',
        fontWeight: FontWeight.w600,
        color: AppTheme.textColor, // Use theme color
        height: 1.4,
      ),
      h3: textTheme.titleLarge?.copyWith(
        // fontFamily: 'Chillax', // Optional: Use Chillax for h3 too
        fontWeight: FontWeight.w600,
        color: AppTheme.textColor.withOpacity(0.9),
        height: 1.4,
      ),
      p: textTheme.bodyLarge?.copyWith(
        height: 1.6, // Increase line spacing for readability
        color: AppTheme.textColor.withOpacity(0.85),
        // Use Satoshi font implicitly from the theme
      ),
      listBullet: textTheme.bodyLarge?.copyWith(
        height: 1.6,
        color: AppTheme.textColor.withOpacity(0.85),
      ),
      // Add styling for other elements like blockquotes, code blocks, etc.
      blockquoteDecoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        border: Border(
          left: BorderSide(color: AppTheme.primaryColor, width: 4),
        ),
      ),
      blockquotePadding: const EdgeInsets.all(12),
      codeblockDecoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      codeblockPadding: const EdgeInsets.all(12),
      code: theme.textTheme.bodyMedium?.copyWith(
        fontFamily: 'monospace', // Use a monospace font for inline code
        backgroundColor: Colors.grey[200],
        fontSize:
            (theme.textTheme.bodyLarge?.fontSize ?? 16) *
            0.9, // Slightly smaller
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.grey.shade300),
        ),
      ),
    );
  }

  // Example of a styled section header (can be used within Markdown or separately)
  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontFamily: 'Chillax',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
