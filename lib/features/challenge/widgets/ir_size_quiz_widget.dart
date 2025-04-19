import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/challenge_step.dart';
import '../../../core/theme/app_theme.dart'; // For consistent styling

class IRSizeQuizWidget extends ConsumerWidget {
  final IRSizeQuizStep step;
  final Function(int) onSelected;
  final int? selectedIndex;

  const IRSizeQuizWidget({
    super.key,
    required this.step,
    required this.onSelected,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (step.instruction != null) ...[
            Text(
              step.instruction!,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
          ],
          Text(step.question, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: step.options.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: selectedIndex == index ? 4 : 1,
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color:
                          selectedIndex == index
                              ? AppTheme.primaryColor
                              : Colors.grey.shade300,
                      width: selectedIndex == index ? 2 : 1,
                    ),
                  ),
                  child: RadioListTile<int>(
                    title: Text(step.options[index]),
                    value: index,
                    groupValue: selectedIndex,
                    onChanged: (value) {
                      if (value != null) {
                        onSelected(value);
                      }
                    },
                    activeColor: AppTheme.primaryColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
