// positioning_practice_screen.dart
import 'package:alarp/features/practice/widgets/simple_model_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../models/positioning_state.dart';
import '../models/collimation_state.dart';
import '../controllers/positioning_controller.dart';
import '../widgets/model_viewer_widget.dart';
import '../widgets/control_panel_widget.dart';

class PositioningPracticeScreen extends StatelessWidget {
  final String bodyPart;
  final String projectionName;

  const PositioningPracticeScreen({
    Key? key,
    required this.bodyPart,
    required this.projectionName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create the providers for state management
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PositioningState()),
        ChangeNotifierProvider(create: (_) => CollimationState()),
        ChangeNotifierProxyProvider2<
          PositioningState,
          CollimationState,
          PositioningController
        >(
          create:
              (context) => PositioningController(
                positioningState: Provider.of<PositioningState>(
                  context,
                  listen: false,
                ),
                collimationState: Provider.of<CollimationState>(
                  context,
                  listen: false,
                ),
              ),
          update: (context, positioningState, collimationState, previous) {
            if (previous == null) {
              return PositioningController(
                positioningState: positioningState,
                collimationState: collimationState,
              );
            }
            return previous;
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final controller = Provider.of<PositioningController>(context);

          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: AppBar(
              title: Text('$bodyPart: $projectionName'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: IconButton(
                    icon: const Icon(SolarIconsOutline.checkCircle),
                    onPressed: () {
                      // Show result dialog with accuracy information
                      _showResultDialog(context, controller);
                    },
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                // Top part - 3D model viewer
                Padding(
                  padding: const EdgeInsets.all(16),
                  // Use the fallback if you're having issues with Flutter3DViewer
                  // child: ModelViewerWidget(),
                  child:
                      SimpleModelViewer(), // Uncomment this and comment out the line above
                ),

                // Bottom part - Control panels
                const Expanded(child: ControlPanelWidget()),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showResultDialog(
    BuildContext context,
    PositioningController controller,
  ) {
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

                // Accuracy statistics
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
