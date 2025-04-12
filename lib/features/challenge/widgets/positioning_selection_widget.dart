import 'package:flutter/material.dart';
import '../models/challenge_step.dart';

class PositioningSelectionWidget extends StatelessWidget {
  final PositioningSelectionStep step;
  final Function(int) onSelected;
  final int? selectedIndex;

  const PositioningSelectionWidget({
    super.key,
    required this.step,
    required this.onSelected,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.instruction,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true, // Important for nested scrolling
            physics:
                const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0, // Make items square
            ),
            itemCount: step.imageOptions.length,
            itemBuilder: (context, index) {
              final isSelected = selectedIndex == index;
              return InkWell(
                onTap: () => onSelected(index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                      width: isSelected ? 3 : 1,
                    ),
                    image: DecorationImage(
                      // Use placeholder images for now
                      image: AssetImage(step.imageOptions[index]),
                      fit: BoxFit.cover, // Adjust fit as needed
                      colorFilter:
                          isSelected
                              ? ColorFilter.mode(
                                Colors.black.withOpacity(0.1),
                                BlendMode.darken,
                              )
                              : null,
                    ),
                  ),
                  child:
                      isSelected
                          ? Center(
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          )
                          : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
