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
    final bool isAnswered = selectedIndex != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (step.instruction != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                step.instruction!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8, // Adjust aspect ratio as needed
            ),
            itemCount: step.imageAssets.length,
            itemBuilder: (context, index) {
              final optionAssetPath = step.imageAssets[index];
              final isSelected = selectedIndex == index;
              final isCorrectAnswer = index == step.correctAnswerIndex;

              // Determine border color and icon based on selection and correctness
              Color borderColor = Colors.grey.shade300;
              IconData? resultIcon;
              Color? resultIconColor;

              if (isAnswered && isSelected) {
                if (wasCorrect == true) {
                  borderColor = Colors.green.shade400;
                  resultIcon = SolarIconsBold.checkCircle;
                  resultIconColor = Colors.green.shade700;
                } else if (wasCorrect == false) {
                  borderColor = Colors.red.shade400;
                  resultIcon = SolarIconsBold.closeCircle;
                  resultIconColor = Colors.red.shade700;
                }
              } else if (isAnswered && isCorrectAnswer) {
                // Optionally highlight the correct answer if the user chose wrong
                // borderColor = Colors.green.withOpacity(0.5);
              }

              return GestureDetector(
                onTap: isAnswered ? null : () => onSelected(index),
                child: Opacity(
                  // Dim unselected options slightly after answering
                  opacity: isAnswered && !isSelected ? 0.6 : 1.0,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: borderColor,
                        width: isSelected ? 2.5 : 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.asset(
                                optionAssetPath,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                          ),
                                        ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ), // Add some padding at the bottom
                          ],
                        ),
                        // Display result icon overlay if answered and selected
                        if (isAnswered && isSelected && resultIcon != null)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(
                                  (255 * 0.1).round(),
                                ),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(
                                      (255 * 0.8).round(),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    resultIcon,
                                    color: resultIconColor,
                                    size: 40,
                                  ),
                                ),
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
