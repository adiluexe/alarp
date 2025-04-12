// positioning_practice_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:solar_icons/solar_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../models/collimation_state.dart';
import '../controllers/positioning_controller.dart';
import '../widgets/collimation_controls_widget.dart';
import '../widgets/model_viewer_widget.dart' show CollimationPainter;
import '../models/body_part.dart'; // Import BodyPart to find image
import '../models/body_region.dart'; // Import BodyRegions to find BodyPart

class PositioningPracticeScreen extends ConsumerWidget {
  final String bodyPart;
  final String projectionName;

  const PositioningPracticeScreen({
    Key? key,
    required this.bodyPart,
    required this.projectionName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(positioningControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('$bodyPart: $projectionName'),
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(SolarIconsOutline.checkCircle),
              onPressed: () {
                _showResultDialog(context, ref);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            // child: ModelViewerWidget(),
          ),
          // const Expanded(child: ControlPanelWidget()),
        ],
      ),
    );
  }

  void _showResultDialog(BuildContext context, WidgetRef ref) {
    final controller = ref.read(positioningControllerProvider);
    final isCorrect = controller.isCorrect;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              isCorrect ? 'Correctly Positioned!' : 'Not Quite Right',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isCorrect ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCorrect
                      ? SolarIconsBold.checkCircle
                      : SolarIconsBold.infoCircle,
                  color: isCorrect ? Colors.green : Colors.orange,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  isCorrect
                      ? 'Great job! Your positioning is correct.'
                      : 'Your positioning needs some adjustments.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildAccuracyRow(
                  context,
                  label: 'Positioning Accuracy',
                  value: controller.positioningAccuracy,
                ),
                const SizedBox(height: 8),
                _buildAccuracyRow(
                  context,
                  label: 'Collimation Accuracy',
                  value: controller.collimationAccuracy,
                ),
                const Divider(height: 24),
                _buildAccuracyRow(
                  context,
                  label: 'Overall Accuracy',
                  value: controller.overallAccuracy,
                  isTotal: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(isCorrect ? 'Continue' : 'Try Again'),
              ),
            ],
          ),
    );
  }

  Widget _buildAccuracyRow(
    BuildContext context, {
    required String label,
    required double value,
    bool isTotal = false,
  }) {
    Color color;
    if (value >= 90) {
      color = Colors.green;
    } else if (value >= 70) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.w600 : null,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${value.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
