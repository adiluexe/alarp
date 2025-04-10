import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../models/positioning_state.dart';
import '../models/collimation_state.dart';

class ModelViewerWidget extends StatefulWidget {
  const ModelViewerWidget({Key? key}) : super(key: key);

  @override
  State<ModelViewerWidget> createState() => _ModelViewerWidgetState();
}

class _ModelViewerWidgetState extends State<ModelViewerWidget> {
  // Controller reference
  Flutter3DController? controller;
  bool isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final posState = Provider.of<PositioningState>(context);
    final colState = Provider.of<CollimationState>(context);

    // Update the model position and rotation whenever state changes
    if (isInitialized && controller != null) {
      _updateModelTransform(posState);
    }

    return Stack(
      children: [
        // 3D Model container
        Container(
          height: 350,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Flutter3DViewer(
              src: 'assets/models/test.glb', // Correct parameter name is 'src'
              enableTouch: true, // Instead of cameraControls
              controller: controller, // Pass the controller
              activeGestureInterceptor: true,
              progressBarColor: AppTheme.primaryColor,
              onLoad: (String modelAddress) {
                debugPrint('Model loaded: $modelAddress');
                setState(() {
                  isInitialized = true;
                });
                _updateModelTransform(posState);
              },
              onProgress: (double progress) {
                debugPrint('Loading progress: $progress');
              },
              onError: (error) {
                debugPrint('Error loading model: $error');
                // You could show an error message to the user here
              },
            ),
          ),
        ),

        // Collimation overlay
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: CollimationPainter(
                width: colState.width,
                height: colState.height,
                centerX: colState.centerX,
                centerY: colState.centerY,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Update model transform based on positioning state
  void _updateModelTransform(PositioningState state) {
    if (!isInitialized || controller == null) return;

    // Convert rotation to orbit
    // For camera orbital control (using actual API methods)
    controller!.setCameraOrbit(
      state.rotationX,
      state.rotationY,
      10 + state.positionZ, // Use Z position to control zoom
    );

    // For target position
    controller!.setCameraTarget(
      state.positionX,
      state.positionY,
      0, // Keep Z at 0 for target
    );

    // Note: There's no direct setScale method in the API
    // If needed, use setCameraOrbit's third parameter to control zoom
  }
}

// CollimationPainter class remains unchanged
class CollimationPainter extends CustomPainter {
  final double width;
  final double height;
  final double centerX;
  final double centerY;

  CollimationPainter({
    required this.width,
    required this.height,
    required this.centerX,
    required this.centerY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppTheme.primaryColor.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    // Calculate box coordinates based on width/height (as percentage of view)
    final double boxWidth = size.width * width;
    final double boxHeight = size.height * height;
    final double boxLeft =
        (size.width - boxWidth) / 2 + (centerX * size.width * 0.2);
    final double boxTop =
        (size.height - boxHeight) / 2 + (centerY * size.height * 0.2);

    // Draw collimation box
    final rect = Rect.fromLTWH(boxLeft, boxTop, boxWidth, boxHeight);
    canvas.drawRect(rect, paint);

    // Draw cross lines
    final crossPaint =
        Paint()
          ..color = AppTheme.primaryColor.withOpacity(0.5)
          ..strokeWidth = 1.0;

    // Horizontal line
    canvas.drawLine(
      Offset(boxLeft, boxTop + boxHeight / 2),
      Offset(boxLeft + boxWidth, boxTop + boxHeight / 2),
      crossPaint,
    );

    // Vertical line
    canvas.drawLine(
      Offset(boxLeft + boxWidth / 2, boxTop),
      Offset(boxLeft + boxWidth / 2, boxTop + boxHeight),
      crossPaint,
    );
  }

  @override
  bool shouldRepaint(CollimationPainter oldDelegate) {
    return width != oldDelegate.width ||
        height != oldDelegate.height ||
        centerX != oldDelegate.centerX ||
        centerY != oldDelegate.centerY;
  }
}
