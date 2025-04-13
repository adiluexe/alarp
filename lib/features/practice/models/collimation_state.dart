// collimation_state.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Represents the immutable state data
@immutable
class CollimationStateData {
  final double width;
  final double height;
  final double centerX;
  final double centerY;
  final double angle; // Add angle property

  const CollimationStateData({
    this.width = 0.5, // Default width
    this.height = 0.5, // Default height
    this.centerX = 0.0, // Default center X
    this.centerY = 0.0, // Default center Y
    this.angle = 0.0, // Default angle (degrees)
  });

  // Initial state
  factory CollimationStateData.initial() => const CollimationStateData();

  // CopyWith method for immutability
  CollimationStateData copyWith({
    double? width,
    double? height,
    double? centerX,
    double? centerY,
    double? angle, // Add angle to copyWith
  }) {
    return CollimationStateData(
      width: width ?? this.width,
      height: height ?? this.height,
      centerX: centerX ?? this.centerX,
      centerY: centerY ?? this.centerY,
      angle: angle ?? this.angle, // Handle angle
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollimationStateData &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          centerX == other.centerX &&
          centerY == other.centerY &&
          angle == other.angle; // Compare angle

  @override
  int get hashCode =>
      width.hashCode ^
      height.hashCode ^
      centerX.hashCode ^
      centerY.hashCode ^
      angle.hashCode; // Include angle in hash
}

// StateNotifier class
class CollimationStateNotifier extends StateNotifier<CollimationStateData> {
  CollimationStateNotifier() : super(CollimationStateData.initial());

  void updateSize({double? newWidth, double? newHeight}) {
    state = state.copyWith(
      // Clamp width and height to new min value 0.1
      width: (newWidth ?? state.width).clamp(0.1, 1.0),
      height: (newHeight ?? state.height).clamp(0.1, 1.0),
    );
  }

  void updateCrossPosition({double? x, double? y}) {
    state = state.copyWith(
      centerX: x ?? state.centerX,
      centerY: y ?? state.centerY,
    );
  }

  // Add method to update angle
  void updateAngle(double newAngle) {
    state = state.copyWith(angle: newAngle);
  }

  void reset() {
    state = CollimationStateData.initial();
  }
}

// StateNotifierProvider
final collimationStateProvider =
    StateNotifierProvider<CollimationStateNotifier, CollimationStateData>((
      ref,
    ) {
      return CollimationStateNotifier();
    });
