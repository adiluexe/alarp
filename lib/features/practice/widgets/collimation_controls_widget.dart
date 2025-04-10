// collimation_controls_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import 'package:alarp/features/practice/models/collimation_state.dart';
import 'package:alarp/features/practice/controllers/positioning_controller.dart';

class CollimationControlsWidget extends StatelessWidget {
  const CollimationControlsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colState = Provider.of<CollimationState>(context);
    final controller = Provider.of<PositioningController>(context);

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
                      colState.updateSize(newWidth: value);
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
                      colState.updateSize(newHeight: value);
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
                      colState.updateCrossPosition(x: value);
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
                      colState.updateCrossPosition(y: value);
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

          const SizedBox(height: 16),

          // Reset button - outside of the scrolling area
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset Collimation'),
              onPressed: () {
                colState.reset();
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
