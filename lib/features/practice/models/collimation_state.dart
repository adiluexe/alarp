// collimation_state.dart
import 'package:flutter/material.dart';

class CollimationState with ChangeNotifier {
  // Collimation box dimensions (0-1 range, representing percentage of view)
  double width = 0.7;
  double height = 0.7;

  // Cross position
  double centerX = 0;
  double centerY = 0;

  void updateSize({double? newWidth, double? newHeight}) {
    if (newWidth != null) width = newWidth;
    if (newHeight != null) height = newHeight;
    notifyListeners();
  }

  void updateCrossPosition({double? x, double? y}) {
    if (x != null) centerX = x;
    if (y != null) centerY = y;
    notifyListeners();
  }

  void reset() {
    width = 0.7;
    height = 0.7;
    centerX = 0;
    centerY = 0;
    notifyListeners();
  }
}
