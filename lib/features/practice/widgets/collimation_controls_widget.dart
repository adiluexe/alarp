// collimation_controls_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/theme/app_theme.dart';
import 'package:alarp/features/practice/models/collimation_state.dart';
import 'package:alarp/features/practice/controllers/collimation_controller.dart'; // Import needed for CollimationParams

class CollimationControlsWidget extends ConsumerWidget {
  // Accept the combined parameters
  final CollimationParams params;

  const CollimationControlsWidget({
    Key? key,
    required this.params, // Make it required
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colState = ref.watch(collimationStateProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
                    min: 0.1,
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
                    min: 0.1,
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
                  _buildSliderControl(
                    context,
                    label: 'Angulation',
                    value: colState.angle,
                    min: -45.0,
                    max: 45.0,
                    divisions: 90,
                    displayValueMultiplier: 1,
                    displayValueSuffix: '°',
                    onChanged: (value) {
                      ref
                          .read(collimationStateProvider.notifier)
                          .updateAngle(value);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
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
    double displayValueMultiplier = 1.0,
    String displayValueSuffix = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '${(value * displayValueMultiplier).toStringAsFixed(1)}$displayValueSuffix',
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
            divisions: divisions,
            activeColor: AppTheme.secondaryColor,
            inactiveColor: AppTheme.secondaryColor.withOpacity(0.2),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
