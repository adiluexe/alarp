import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../models/positioning_state.dart';
import '../models/collimation_state.dart';

class SimpleModelViewer extends StatelessWidget {
  const SimpleModelViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final posState = Provider.of<PositioningState>(context);
    final colState = Provider.of<CollimationState>(context);

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
            child: Center(
              child: Transform(
                transform:
                    Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // perspective
                      ..rotateX(posState.rotationX * 3.14159 / 180)
                      ..rotateY(posState.rotationY * 3.14159 / 180)
                      ..rotateZ(posState.rotationZ * 3.14159 / 180)
                      ..scale(posState.scale),
                alignment: Alignment.center,
                child: Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Model',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
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
}

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
