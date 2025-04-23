import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import '../models/challenge_step.dart';

class PositioningSelectionWidget extends StatelessWidget {
  final PositioningSelectionStep step;
  final Function(int) onSelected;
  final int? selectedIndex;
  final bool? wasCorrect; // Added: Pass correctness status

  const PositioningSelectionWidget({
    super.key,
    required this.step,
    required this.onSelected,
    this.selectedIndex,
    this.wasCorrect, // Added
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isAnswered = selectedIndex != null;

    return SingleChildScrollView(
      // Use ListView for better structure if content might overflow vertically
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 24.0,
      ), // Adjusted padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Combined Question and Instruction Area
          Padding(
            padding: const EdgeInsets.only(
              bottom: 24.0,
            ), // Increased bottom padding
            child: Column(
              children: [
                Text(
                  step.question.isNotEmpty
                      ? step.question
                      : 'Which image shows the correct positioning?', // Simplified default
                  style: theme.textTheme.headlineSmall?.copyWith(
                    // Use a headline style
                    fontWeight:
                        FontWeight
                            .w600, // Slightly less bold than Chillax default
                    color: colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (step.instruction != null && step.instruction!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                    ), // Space between question and instruction
                    child: Text(
                      step.instruction!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onBackground.withOpacity(
                          0.7,
                        ), // Softer color
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85, // Slightly taller aspect ratio
            ),
            itemCount: step.imageAssets.length,
            itemBuilder: (context, index) {
              final optionAssetPath = step.imageAssets[index];
              final isSelected = selectedIndex == index;
              final isCorrectAnswer = index == step.correctAnswerIndex;

              // Determine border color and icon based on selection and correctness
              Color borderColor = colorScheme.outline.withOpacity(
                0.3,
              ); // Use theme outline
              IconData? resultIcon;
              Color? resultIconColor;
              Color? overlayColor;
              double borderWidth = 1.5; // Default border width
              double elevation = 1.0; // Default elevation

              if (isAnswered && isSelected) {
                borderWidth = 3.0; // Thicker border for selected
                elevation = 3.0; // More elevation for selected
                if (wasCorrect == true) {
                  borderColor = Colors.green; // Solid green border
                  resultIcon = SolarIconsBold.checkCircle;
                  resultIconColor =
                      Colors.white; // White icon for contrast on overlay
                  overlayColor = Colors.green.withOpacity(0.6); // Green overlay
                } else if (wasCorrect == false) {
                  borderColor = Colors.red; // Solid red border
                  resultIcon = SolarIconsBold.closeCircle;
                  resultIconColor =
                      Colors.white; // White icon for contrast on overlay
                  overlayColor = Colors.red.withOpacity(0.6); // Red overlay
                }
              } else if (isAnswered && isCorrectAnswer) {
                // Highlight the correct answer subtly if the user chose wrong
                borderColor = Colors.green.withOpacity(0.7);
                borderWidth = 2.0;
              }

              return GestureDetector(
                onTap: isAnswered ? null : () => onSelected(index),
                child: Opacity(
                  // Dim unselected options slightly after answering
                  opacity:
                      (isAnswered && !isSelected && !isCorrectAnswer)
                          ? 0.5
                          : 1.0,
                  child: Card(
                    elevation: elevation, // Apply elevation
                    shadowColor: colorScheme.shadow.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // More rounded corners
                      side: BorderSide(
                        color: borderColor,
                        width: borderWidth, // Apply dynamic border width
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      alignment: Alignment.center, // Center stack children
                      children: [
                        // Image container
                        Positioned.fill(
                          child: ClipRRect(
                            // Clip the image to rounded corners
                            borderRadius: BorderRadius.circular(
                              15.0,
                            ), // Match card radius - 1
                            child: Image.asset(
                              optionAssetPath,
                              fit:
                                  BoxFit
                                      .cover, // Cover ensures image fills the card
                              errorBuilder:
                                  (context, error, stackTrace) => Center(
                                    child: Icon(
                                      SolarIconsOutline
                                          .galleryRemove, // Corrected icon
                                      color: Colors.grey.shade400,
                                      size: 48,
                                    ),
                                  ),
                            ),
                          ),
                        ),

                        // Display result icon overlay if answered and selected
                        if (isAnswered &&
                            isSelected &&
                            resultIcon != null &&
                            overlayColor != null)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    overlayColor, // Use dynamic overlay color
                                borderRadius: BorderRadius.circular(
                                  15,
                                ), // Match image clip
                              ),
                              child: Center(
                                child: Icon(
                                  resultIcon,
                                  color:
                                      resultIconColor, // Use dynamic icon color
                                  size: 60, // Larger icon
                                ),
                              ),
                            ),
                          ),
                        // Optionally show a subtle checkmark for the correct answer if user chose wrong
                        if (isAnswered &&
                            !isSelected &&
                            isCorrectAnswer &&
                            wasCorrect == false)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                SolarIconsOutline.checkCircle,
                                color: Colors.greenAccent.withOpacity(0.9),
                                size: 24,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
