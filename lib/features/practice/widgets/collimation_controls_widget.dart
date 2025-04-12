// collimation_controls_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Add riverpod import
import '../../../core/theme/app_theme.dart';
// Import providers
import 'package:alarp/features/practice/models/collimation_state.dart';
import 'package:alarp/features/practice/controllers/positioning_controller.dart';

// Change to ConsumerWidget
class CollimationControlsWidget extends ConsumerWidget {
  const CollimationControlsWidget({Key? key}) : super(key: key);

  @override
  // Add WidgetRef ref
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state provider
    final colState = ref.watch(collimationStateProvider);
    // Watch the controller provider
    final controller = ref.watch(positioningControllerProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      // Use a Column with defined constraints instead of SingleChildScrollView
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize:
            MainAxisSize.min, // Important: this fixes unbounded height
        children: [
          Text(
            'Adjust Collimation Field',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          // Wrap the sliders in an Expanded + SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Width adjustment
                  _buildSliderControl(
                    context,
                    label: 'Field Width',
                    value: colState.width,
                    min: 0.2,
                    max: 1.0,
                    onChanged: (value) {
                      // Read the notifier to call methods
                      ref
                          .read(collimationStateProvider.notifier)
                          .updateSize(newWidth: value);
                    },
                  ),

                  // Height adjustment
                  _buildSliderControl(
                    context,
                    label: 'Field Height',
                    value: colState.height,
                    min: 0.2,
                    max: 1.0,
                    onChanged: (value) {
                      // Read the notifier to call methods
                      ref
                          .read(collimationStateProvider.notifier)
                          .updateSize(newHeight: value);
                    },
                  ),

                  // Cross position X
                  _buildSliderControl(
                    context,
                    label: 'Horizontal Centering',
                    value: colState.centerX,
                    min: -1.0,
                    max: 1.0,
                    onChanged: (value) {
                      // Read the notifier to call methods
                      ref
                          .read(collimationStateProvider.notifier)
                          .updateCrossPosition(x: value);
                    },
                  ),

                  // Cross position Y
                  _buildSliderControl(
                    context,
                    label: 'Vertical Centering',
                    value: colState.centerY,
                    min: -1.0,
                    max: 1.0,
                    onChanged: (value) {
                      // Read the notifier to call methods
                      ref
                          .read(collimationStateProvider.notifier)
                          .updateCrossPosition(y: value);
                    },
                  ),

                  const SizedBox(height: 16),

                  // Accuracy indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Collimation Accuracy:',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getAccuracyColor(
                            controller
                                .collimationAccuracy, // Use controller value
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${controller.collimationAccuracy.toStringAsFixed(1)}%', // Use controller value
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Reset button - outside of the scrolling area
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset Collimation'),
              onPressed: () {
                // Read the notifier to call methods
                ref.read(collimationStateProvider.notifier).reset();
              },
            ),
          ),
        ],
      ),
    );
  }

  // _buildSliderControl remains the same
  Widget _buildSliderControl(
    BuildContext context, {
    required String label,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
    int? divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              ((value * 100) / 100).toStringAsFixed(2),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions ?? 100,
            activeColor: AppTheme.secondaryColor,
            inactiveColor: AppTheme.secondaryColor.withOpacity(0.2),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // _getAccuracyColor remains the same
  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 90) return Colors.green;
    if (accuracy >= 70) return Colors.orange;
    return Colors.red;
  }
}
