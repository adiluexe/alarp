import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import '../models/challenge_step.dart';
import '../../../core/theme/app_theme.dart'; // For consistent styling

class IROrientationQuizWidget extends ConsumerWidget {
  final IROrientationQuizStep step;
  final Function(int) onSelected;
  final int? selectedIndex;
  final bool? wasCorrect; // Added

  const IROrientationQuizWidget({
    super.key,
    required this.step,
    required this.onSelected,
    this.selectedIndex,
    this.wasCorrect, // Added
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bool isAnswered = selectedIndex != null;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (step.instruction != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              step.instruction!,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ...List.generate(step.options.length, (index) {
          final option = step.options[index];
          final isSelected = selectedIndex == index;
          final isCorrectAnswer = index == step.correctAnswerIndex;

          // Determine background color, border color, and icon
          Color backgroundColor = theme.cardColor;
          Color borderColor = Colors.grey.shade300;
          Color textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
          IconData? resultIcon;
          Color? resultIconColor;

          if (isAnswered && isSelected) {
            if (wasCorrect == true) {
              backgroundColor = Colors.green.shade50;
              borderColor = Colors.green.shade400;
              textColor = Colors.green.shade800;
              resultIcon = SolarIconsBold.checkCircle;
              resultIconColor = Colors.green.shade700;
            } else if (wasCorrect == false) {
              backgroundColor = Colors.red.shade50;
              borderColor = Colors.red.shade400;
              textColor = Colors.red.shade800;
              resultIcon = SolarIconsBold.closeCircle;
              resultIconColor = Colors.red.shade700;
            }
          } else if (isAnswered && isCorrectAnswer) {
            // Optionally highlight correct if wrong was chosen
            // borderColor = Colors.green.withOpacity(0.5);
          }

          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: borderColor, width: isSelected ? 2.0 : 1),
            ),
            child: InkWell(
              onTap: isAnswered ? null : () => onSelected(index),
              borderRadius: BorderRadius.circular(12),
              child: Opacity(
                opacity: isAnswered && !isSelected ? 0.6 : 1.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 18.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option, // Assuming options are Strings
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                      if (isAnswered && isSelected && resultIcon != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Icon(
                            resultIcon,
                            color: resultIconColor,
                            size: 28,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
