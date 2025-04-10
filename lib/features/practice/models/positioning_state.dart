// positioning_state.dart
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class PositioningState with ChangeNotifier {
  // Rotation in degrees
  double rotationX = 0;
  double rotationY = 0;
  double rotationZ = 0;

  // Position offsets
  double positionX = 0;
  double positionY = 0;
  double positionZ = 0;

  // Model scale
  double scale = 1.0;

  // Update rotation
  void updateRotation({double? x, double? y, double? z}) {
    if (x != null) rotationX = x;
    if (y != null) rotationY = y;
    if (z != null) rotationZ = z;
    notifyListeners();
  }

  // Update position
  void updatePosition({double? x, double? y, double? z}) {
    if (x != null) positionX = x;
    if (y != null) positionY = y;
    if (z != null) positionZ = z;
    notifyListeners();
  }

  // Update scale
  void updateScale(double newScale) {
    scale = newScale;
    notifyListeners();
  }

  // Reset all values
  void reset() {
    rotationX = 0;
    rotationY = 0;
    rotationZ = 0;
    positionX = 0;
    positionY = 0;
    positionZ = 0;
    scale = 1.0;
    notifyListeners();
  }

  // Get quaternion for rotation
  vector.Quaternion get quaternion {
    return vector.Quaternion.euler(
      rotationX * (3.14159 / 180),
      rotationY * (3.14159 / 180),
      rotationZ * (3.14159 / 180),
    );
  }
}
