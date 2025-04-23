import 'package:alarp/core/theme/app_theme.dart'; // Import AppTheme
import 'package:alarp/features/practice/models/practice_attempt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Keep for potential future date formatting
import 'package:solar_icons/solar_icons.dart'; // Import Solar Icons
import 'package:timeago/timeago.dart' as timeago; // Use timeago

// Helper function to capitalize the first letter of each word and after parentheses
String _capitalize(String s) {
  if (s.isEmpty) return s;

  // Capitalize the very first letter and letters after spaces
  String capitalized = s
      .split(' ')
      .map((word) {
        if (word.isEmpty) return '';
        // Standard capitalization for words not starting with '('
        if (!word.startsWith('(')) {
          return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
        }
        // Handle words starting with '(' - keep '(' and capitalize next letter if present
        if (word.length > 1) {
          return '(${word[1].toUpperCase()}${word.substring(2).toLowerCase()}';
        }
        // Only parenthesis
        return word;
      })
      .join(' ');

  // Ensure capitalization directly after '(' even without a space (e.g., "word(anotherWord)")
  // This regex finds '(' followed by a letter and replaces the letter with its uppercase version.
  capitalized = capitalized.replaceAllMapped(
    RegExp(r'\((\w)'), // Find '(' followed by a word character
    (match) =>
        '(${match.group(1)!.toUpperCase()}', // Replace with '(' + uppercase letter
  );

  return capitalized;
}

class RecentPracticeItem extends ConsumerWidget {
  final PracticeAttempt attempt;

  const RecentPracticeItem({
    required this.attempt,
    super.key,
  }); // Use super parameters

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context); // Access theme via context
    final timeAgoString = timeago.format(attempt.createdAt); // Format time

    // Use AppTheme colors directly for clarity if needed, or rely on theme context
    final Color accuracyColor =
        attempt.accuracy >= 80
            ? Colors
                .green
                .shade600 // Consider defining these in AppTheme if used elsewhere
            : attempt.accuracy >= 60
            ? Colors.orange.shade700
            : Colors.red.shade600;

    return Card(
      // Use CardTheme from AppTheme implicitly
      // margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0), // Use CardTheme margin
      // elevation: Use CardTheme elevation
      // shape: Use CardTheme shape
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(
              0.1,
            ), // Light background
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
          child: Icon(
            SolarIconsOutline.document, // Example icon
            color: theme.colorScheme.primary, // Use primary color from theme
            size: 24, // Slightly smaller icon inside the background
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0, // Slightly increase vertical padding
        ),
        title: Text(
          // Capitalize names
          '${_capitalize(attempt.bodyPartId)} - ${_capitalize(attempt.projectionName)}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold, // Keep bold
            // fontFamily: 'Satoshi', // Already default via theme
          ),
          maxLines: 2, // Allow wrapping
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Completed $timeAgoString', // Use formatted time
          style: theme.textTheme.bodySmall?.copyWith(
            // color: theme.textTheme.bodySmall?.color?.withOpacity(0.7), // Default from theme
            // fontFamily: 'Satoshi', // Already default via theme
          ),
        ),
        trailing: Text(
          '${attempt.accuracy.toStringAsFixed(1)}%', // Access correct property and format
          style: theme.textTheme.titleMedium?.copyWith(
            // Use titleMedium for consistency
            color: accuracyColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Chillax', // Keep Chillax for emphasis on score
          ),
        ),
        // Optional: Add onTap to navigate to details if needed
        // onTap: () {
        //   // Navigate to a detailed view of this attempt
        // },
      ),
    );
  }
}
