import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import '../models/challenge_step.dart';

class IROrientationQuizWidget extends ConsumerWidget {
  final IROrientationQuizStep step;
  final Function(int) onSelected;
  final int? selectedIndex;
  final bool? wasCorrect;

  const IROrientationQuizWidget({
    super.key,
    required this.step,
    required this.onSelected,
    this.selectedIndex,
    this.wasCorrect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isAnswered = selectedIndex != null;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      children: [
        if (step.instruction != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              step.instruction!,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ...List.generate(step.options.length, (index) {
          final option = step.options[index];
          final isSelected = selectedIndex == index;
          final isCorrectAnswer = index == step.correctAnswerIndex;

          Color cardColor = colorScheme.surface;
          Color borderColor = colorScheme.outline.withOpacity(0.3);
          Color textColor = colorScheme.onSurface;
          IconData? resultIcon;
          Color? resultIconColor;
          double elevation = 1.0;
          double borderWidth = 1.5;

          if (isAnswered && isSelected) {
            elevation = 2.0;
            borderWidth = 2.5;
            if (wasCorrect == true) {
              cardColor = Colors.green.shade50;
              borderColor = Colors.green;
              textColor = Colors.green.shade900;
              resultIcon = SolarIconsBold.checkCircle;
              resultIconColor = Colors.green.shade700;
            } else if (wasCorrect == false) {
              cardColor = Colors.red.shade50;
              borderColor = Colors.red;
              textColor = Colors.red.shade900;
              resultIcon = SolarIconsBold.closeCircle;
              resultIconColor = Colors.red.shade700;
            }
          } else if (isAnswered && isCorrectAnswer) {
            borderColor = Colors.green.withOpacity(0.6);
            borderWidth = 2.0;
          } else if (isAnswered && !isSelected) {
            textColor = textColor.withOpacity(0.6);
          }

          return Card(
            elevation: elevation,
            margin: const EdgeInsets.only(bottom: 12),
            color: cardColor,
            shadowColor: colorScheme.shadow.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: borderColor, width: borderWidth),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: isAnswered ? null : () => onSelected(index),
              borderRadius: BorderRadius.circular(15),
              child: Opacity(
                opacity:
                    (isAnswered && !isSelected && !isCorrectAnswer) ? 0.6 : 1.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: textColor,
                            height: 1.4,
                          ),
                        ),
                      ),
                      if (isAnswered && isSelected && resultIcon != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Icon(
                            resultIcon,
                            color: resultIconColor,
                            size: 32,
                          ),
                        ),
                      if (isAnswered &&
                          !isSelected &&
                          isCorrectAnswer &&
                          wasCorrect == false)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Icon(
                            SolarIconsOutline.checkCircle,
                            color: Colors.green.withOpacity(0.8),
                            size: 32,
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
