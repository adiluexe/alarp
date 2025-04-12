import 'package:flutter/material.dart';
import 'package:alarp/core/theme/app_theme.dart'; // Import theme

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
          ..color = AppTheme.primaryColor.withOpacity(
            0.6,
          ) // Slightly more opaque
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    // Calculate box coordinates based on width/height (as percentage of view)
    // Ensure width/height are clamped between 0 and 1
    final double clampedWidth = width.clamp(0.0, 1.0);
    final double clampedHeight = height.clamp(0.0, 1.0);

    final double boxWidth = size.width * clampedWidth;
    final double boxHeight = size.height * clampedHeight;

    // Calculate center offset relative to the view center
    // centerX/Y range from -1 to 1. Max offset is half the remaining space.
    final double maxOffsetX = (size.width - boxWidth) / 2;
    final double maxOffsetY = (size.height - boxHeight) / 2;

    // Clamp centerX/Y to prevent excessive movement if needed, though -1 to 1 is standard
    final double clampedCenterX = centerX.clamp(-1.0, 1.0);
    final double clampedCenterY = centerY.clamp(-1.0, 1.0);

    final double boxLeft =
        (size.width / 2) - (boxWidth / 2) + (clampedCenterX * maxOffsetX);
    final double boxTop =
        (size.height / 2) - (boxHeight / 2) + (clampedCenterY * maxOffsetY);

    // Draw collimation box
    final rect = Rect.fromLTWH(boxLeft, boxTop, boxWidth, boxHeight);
    canvas.drawRect(rect, paint);

    // Draw cross lines centered within the box
    final crossPaint =
        Paint()
          ..color = AppTheme.primaryColor.withOpacity(0.6) // Match opacity
          ..strokeWidth = 1.0;

    final crossCenterX = boxLeft + boxWidth / 2;
    final crossCenterY = boxTop + boxHeight / 2;

    // Horizontal line
    canvas.drawLine(
      Offset(boxLeft, crossCenterY),
      Offset(boxLeft + boxWidth, crossCenterY),
      crossPaint,
    );

    // Vertical line
    canvas.drawLine(
      Offset(crossCenterX, boxTop),
      Offset(crossCenterX, boxTop + boxHeight),
      crossPaint,
    );
  }

  @override
  bool shouldRepaint(CollimationPainter oldDelegate) {
    // Repaint if any value changes
    return width != oldDelegate.width ||
        height != oldDelegate.height ||
        centerX != oldDelegate.centerX ||
        centerY != oldDelegate.centerY;
  }
}
