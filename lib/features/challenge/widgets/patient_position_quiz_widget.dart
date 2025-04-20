import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart'; // Import icons
import '../models/challenge_step.dart';
import '../../../core/theme/app_theme.dart'; // For consistent styling

class PatientPositionQuizWidget extends ConsumerWidget {
  final PatientPositionQuizStep step;
  final Function(int) onSelected;
  final int? selectedIndex;
  final bool? wasCorrect; // Added

  const PatientPositionQuizWidget({
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
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Text(step.question, style: theme.textTheme.titleLarge),
        const SizedBox(height: 24),
        ...step.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedIndex == index;
          final isCorrectAnswer = index == step.correctAnswerIndex;

          Color tileColor = Colors.transparent;
          Color borderColor = Colors.grey.shade300;
          double borderWidth = 1;
          IconData? trailingIcon;
          Color? iconColor;

          if (isAnswered) {
            if (isSelected) {
              if (wasCorrect == true) {
                borderColor = Colors.green.shade400;
                borderWidth = 2;
                tileColor = Colors.green.shade50;
                trailingIcon = SolarIconsBold.checkCircle;
                iconColor = Colors.green.shade700;
              } else if (wasCorrect == false) {
                borderColor = Colors.red.shade400;
                borderWidth = 2;
                tileColor = Colors.red.shade50;
                trailingIcon = SolarIconsBold.closeCircle;
                iconColor = Colors.red.shade700;
              }
            } else if (isCorrectAnswer) {
              // Optionally highlight the correct answer if the user chose wrong
              // tileColor = Colors.green.withOpacity(0.1);
              // borderColor = Colors.green.withOpacity(0.5);
            }
          }

          return Card(
            elevation: 0, // Remove default card elevation
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: borderColor, width: borderWidth),
            ),
            color: tileColor,
            clipBehavior:
                Clip.antiAlias, // Ensure content respects border radius
            child: ListTile(
              title: Text(option),
              leading: Radio<int>(
                value: index,
                groupValue: selectedIndex,
                onChanged:
                    isAnswered
                        ? null
                        : (value) {
                          if (value != null) {
                            onSelected(value);
                          }
                        },
                activeColor: AppTheme.primaryColor,
                // Disable radio button after selection
                fillColor:
                    isAnswered
                        ? MaterialStateProperty.resolveWith<Color?>((
                          Set<MaterialState> states,
                        ) {
                          if (states.contains(MaterialState.selected)) {
                            // Use primary color if selected, even when disabled
                            return AppTheme.primaryColor.withOpacity(0.6);
                          }
                          // Use disabled color if not selected
                          return Colors.grey.withOpacity(0.4);
                        })
                        : null,
              ),
              trailing:
                  trailingIcon != null
                      ? Icon(trailingIcon, color: iconColor)
                      : null,
              onTap:
                  isAnswered
                      ? null
                      : () {
                        onSelected(index);
                      },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              // Dim non-selected options after answering
              enabled: !isAnswered || isSelected,
              selected: isSelected,
              selectedTileColor: tileColor, // Use the calculated tile color
            ),
          );
        }).toList(),
      ],
    );
  }
}
