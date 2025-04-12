// collimation_controls_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart'; // Import Solar Icons for consistency
import '../../../core/theme/app_theme.dart';
import 'package:alarp/features/practice/models/collimation_state.dart';
import 'package:alarp/features/practice/controllers/collimation_controller.dart';

class CollimationControlsWidget extends ConsumerWidget {
  final String projectionName; // Add projectionName parameter

  const CollimationControlsWidget({
    Key? key,
    required this.projectionName, // Make it required
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colState = ref.watch(collimationStateProvider);
    // Watch the specific controller instance using the projectionName
    final controller = ref.watch(collimationControllerProvider(projectionName));

    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        24,
      ), // Add more bottom padding
      // Add decoration for rounded corners
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adjust Collimation Field',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSliderControl(
                    context,
                    label: 'Field Width',
                    value: colState.width,
                    min: 0.2,
                    max: 1.0,
                    onChanged: (value) {
                      ref
                          .read(collimationStateProvider.notifier)
                          .updateSize(newWidth: value);
                    },
                  ),
                  _buildSliderControl(
                    context,
                    label: 'Field Height',
                    value: colState.height,
                    min: 0.2,
                    max: 1.0,
                    onChanged: (value) {
                      ref
                          .read(collimationStateProvider.notifier)
                          .updateSize(newHeight: value);
                    },
                  ),
                  _buildSliderControl(
                    context,
                    label: 'Horizontal Centering',
                    value: colState.centerX,
                    min: -1.0,
                    max: 1.0,
                    onChanged: (value) {
                      ref
                          .read(collimationStateProvider.notifier)
                          .updateCrossPosition(x: value);
                    },
                  ),
                  _buildSliderControl(
                    context,
                    label: 'Vertical Centering',
                    value: colState.centerY,
                    min: -1.0,
                    max: 1.0,
                    onChanged: (value) {
                      ref
                          .read(collimationStateProvider.notifier)
                          .updateCrossPosition(y: value);
                    },
                  ),
                  const SizedBox(height: 16),
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
                            controller.collimationAccuracy,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${controller.collimationAccuracy.toStringAsFixed(1)}%',
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
          const SizedBox(height: 16), // Space before the button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(
                SolarIconsOutline.restart,
                size: 20,
              ), // Use Solar Icon
              label: const Text('Reset Collimation'),
              style: ElevatedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor, // Text/icon color
                backgroundColor: AppTheme.primaryColor.withOpacity(
                  0.1,
                ), // Light background
                elevation: 0, // No shadow
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ), // Increase padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                textStyle: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                ref.read(collimationStateProvider.notifier).reset();
              },
            ),
          ),
        ],
      ),
    );
  }

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

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 90) return Colors.green;
    if (accuracy >= 70) return Colors.orange;
    return Colors.red;
  }
}
