import 'dart:math' as math; // Import math for pi
import 'package:flutter/material.dart';
import 'package:alarp/core/theme/app_theme.dart'; // Import theme

class CollimationPainter extends CustomPainter {
  final double width;
  final double height;
  final double centerX;
  final double centerY;
  final double angle; // Add angle property (in degrees)

  CollimationPainter({
    required this.width,
    required this.height,
    required this.centerX,
    required this.centerY,
    required this.angle, // Require angle
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppTheme.primaryColor.withOpacity(0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    // Clamp width/height (using the new min value 0.1)
    final double clampedWidth = width.clamp(0.1, 1.0);
    final double clampedHeight = height.clamp(0.1, 1.0);

    final double boxWidth = size.width * clampedWidth;
    final double boxHeight = size.height * clampedHeight;

    final double maxOffsetX = (size.width - boxWidth) / 2;
    final double maxOffsetY = (size.height - boxHeight) / 2;

    final double clampedCenterX = centerX.clamp(-1.0, 1.0);
    final double clampedCenterY = centerY.clamp(-1.0, 1.0);

    // Calculate the center point of the box *before* rotation
    final double boxCenterX = (size.width / 2) + (clampedCenterX * maxOffsetX);
    final double boxCenterY = (size.height / 2) + (clampedCenterY * maxOffsetY);

    // Calculate top-left corner based on center and size
    final double boxLeft = boxCenterX - boxWidth / 2;
    final double boxTop = boxCenterY - boxHeight / 2;

    // --- Rotation ---
    canvas.save(); // Save the current canvas state

    // Translate origin to the center of the box
    canvas.translate(boxCenterX, boxCenterY);

    // Rotate the canvas
    canvas.rotate(angle * math.pi / 180); // Convert degrees to radians

    // Translate origin back
    canvas.translate(-boxCenterX, -boxCenterY);
    // --- End Rotation ---

    // Draw collimation box (coordinates are now relative to the rotated canvas)
    final rect = Rect.fromLTWH(boxLeft, boxTop, boxWidth, boxHeight);
    canvas.drawRect(rect, paint);

    // Draw cross lines centered within the box
    final crossPaint =
        Paint()
          ..color = AppTheme.primaryColor.withOpacity(0.6)
          ..strokeWidth = 1.0;

    // Use the calculated box center for cross lines
    // Horizontal line
    canvas.drawLine(
      Offset(boxLeft, boxCenterY), // Use boxCenterY
      Offset(boxLeft + boxWidth, boxCenterY), // Use boxCenterY
      crossPaint,
    );

    // Vertical line
    canvas.drawLine(
      Offset(boxCenterX, boxTop), // Use boxCenterX
      Offset(boxCenterX, boxTop + boxHeight), // Use boxCenterX
      crossPaint,
    );

    canvas.restore(); // Restore the canvas state (removes rotation)
  }

  @override
  bool shouldRepaint(CollimationPainter oldDelegate) {
    // Repaint if any value changes, including angle
    return width != oldDelegate.width ||
        height != oldDelegate.height ||
        centerX != oldDelegate.centerX ||
        centerY != oldDelegate.centerY ||
        angle != oldDelegate.angle; // Check angle
  }
}
