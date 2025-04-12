// position_controls_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Add riverpod import
import '../../../core/theme/app_theme.dart';
// Import providers
import 'package:alarp/features/practice/models/positioning_state.dart';
import 'package:alarp/features/practice/controllers/positioning_controller.dart';

// Change to ConsumerWidget
class PositionControlsWidget extends ConsumerWidget {
  const PositionControlsWidget({Key? key}) : super(key: key);

  @override
  // Add WidgetRef ref
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state provider
    final posState = ref.watch(positioningStateProvider);
    // Watch the controller provider
    final controller = ref.watch(positioningControllerProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Adjust Body Position',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          // Wrap sliders in Expanded to avoid overflow
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rotation X (sagittal plane)
                  _buildSliderControl(
                    context,
                    label: 'Sagittal Rotation (X)',
                    value: posState.rotationX,
                    min: -90,
                    max: 90,
                    onChanged: (value) {
                      // Read the notifier to call methods
                      ref
                          .read(positioningStateProvider.notifier)
                          .updateRotation(x: value);
                    },
                  ),

                  // Rotation Y (coronal plane)
                  _buildSliderControl(
                    context,
                    label: 'Coronal Rotation (Y)',
                    value: posState.rotationY,
                    min: -90,
                    max: 90,
                    onChanged: (value) {
                      // Read the notifier to call methods
                      ref
                          .read(positioningStateProvider.notifier)
                          .updateRotation(y: value);
                    },
                  ),

                  // Rotation Z (transverse plane)
                  _buildSliderControl(
                    context,
                    label: 'Transverse Rotation (Z)',
                    value: posState.rotationZ,
                    min: -90,
                    max: 90,
                    onChanged: (value) {
                      // Read the notifier to call methods
                      ref
                          .read(positioningStateProvider.notifier)
                          .updateRotation(z: value);
                    },
                  ),

                  const SizedBox(height: 16),

                  // Accuracy indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Positioning Accuracy:',
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
                                .positioningAccuracy, // Use controller value
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${controller.positioningAccuracy.toStringAsFixed(1)}%', // Use controller value
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

          // Reset button outside scrolling area
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset Position'),
              onPressed: () {
                // Read the notifier to call methods
                ref.read(positioningStateProvider.notifier).reset();
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
              '${value.toStringAsFixed(1)}°',
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
            divisions: divisions ?? ((max - min).toInt() * 2),
            activeColor: AppTheme.primaryColor,
            inactiveColor: AppTheme.primaryColor.withOpacity(0.2),
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
