import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:solar_icons/solar_icons.dart'; // Import icons
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/learn/controllers/learn_providers.dart';
import 'package:alarp/features/learn/models/lesson.dart';
// Import ModelViewerWidget if you intend to use it
// import 'package:alarp/features/practice/widgets/model_viewer_widget.dart';

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

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(lesson.title),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textColor,
        elevation: 1,
      ),
      // Use ListView for better structure than SingleChildScrollView + Column
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Lesson Title Header (optional, as it's in AppBar)
          // Text(
          //   lesson.title,
          //   style: textTheme.headlineMedium?.copyWith(
          //     fontFamily: 'Chillax',
          //     fontWeight: FontWeight.w700,
          //     color: AppTheme.primaryColor,
          //   ),
          // ),
          // const SizedBox(height: 16),

          // Optional: Display Image with styling
          if (lesson.imageUrl != null)
            _buildMediaContainer(
              context,
              child: Image.asset(
                lesson.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image, size: 48)),
              ),
            ),

          // Optional: Display 3D Model Viewer
          if (lesson.modelPath != null)
            _buildMediaContainer(
              context,
              child: Container(
                // Placeholder for ModelViewerWidget
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '3D Model Placeholder\n(${lesson.modelPath})',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                // TODO: Replace with actual ModelViewerWidget(src: lesson.modelPath!)
              ),
              aspectRatio: 16 / 9, // Adjust aspect ratio if needed
            ),

          // Display Markdown Content with improved styling
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
            ), // Add space above markdown if media exists
            child: MarkdownBody(
              data: lesson.content,
              styleSheet: _buildMarkdownStyleSheet(theme, textTheme),
              // Add custom builders for specific tags if needed
              // e.g., to style bullet points or blockquotes differently
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
            color: Colors.grey[200], // Background for loading/error states
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
