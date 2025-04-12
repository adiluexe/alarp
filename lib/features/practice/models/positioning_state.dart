// positioning_state.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart';

// Represents the immutable state data
@immutable
class PositioningStateData {
  final double rotationX;
  final double rotationY;
  final double rotationZ;
  final double positionX;
  final double positionY;
  final double positionZ;
  final double scale;

  const PositioningStateData({
    this.rotationX = 0.0,
    this.rotationY = 0.0,
    this.rotationZ = 0.0,
    this.positionX = 0.0,
    this.positionY = 0.0,
    this.positionZ = 0.0,
    this.scale = 1.0,
  });

  // Initial state
  factory PositioningStateData.initial() => const PositioningStateData();

  // CopyWith method for immutability
  PositioningStateData copyWith({
    double? rotationX,
    double? rotationY,
    double? rotationZ,
    double? positionX,
    double? positionY,
    double? positionZ,
    double? scale,
  }) {
    return PositioningStateData(
      rotationX: rotationX ?? this.rotationX,
      rotationY: rotationY ?? this.rotationY,
      rotationZ: rotationZ ?? this.rotationZ,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      positionZ: positionZ ?? this.positionZ,
      scale: scale ?? this.scale,
    );
  }

  // Helper to get rotation as Vector3
  Vector3 get rotation => Vector3(rotationX, rotationY, rotationZ);
  // Helper to get position as Vector3
  Vector3 get position => Vector3(positionX, positionY, positionZ);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositioningStateData &&
          runtimeType == other.runtimeType &&
          rotationX == other.rotationX &&
          rotationY == other.rotationY &&
          rotationZ == other.rotationZ &&
          positionX == other.positionX &&
          positionY == other.positionY &&
          positionZ == other.positionZ &&
          scale == other.scale;

  @override
  int get hashCode =>
      rotationX.hashCode ^
      rotationY.hashCode ^
      rotationZ.hashCode ^
      positionX.hashCode ^
      positionY.hashCode ^
      positionZ.hashCode ^
      scale.hashCode;
}

// StateNotifier class
class PositioningStateNotifier extends StateNotifier<PositioningStateData> {
  PositioningStateNotifier() : super(PositioningStateData.initial());

  void updateRotation({double? x, double? y, double? z}) {
    state = state.copyWith(
      rotationX: x ?? state.rotationX,
      rotationY: y ?? state.rotationY,
      rotationZ: z ?? state.rotationZ,
    );
  }

  void updatePosition({double? x, double? y, double? z}) {
    state = state.copyWith(
      positionX: x ?? state.positionX,
      positionY: y ?? state.positionY,
      positionZ: z ?? state.positionZ,
    );
  }

  void updateScale(double newScale) {
    state = state.copyWith(scale: newScale);
  }

  void reset() {
    state = PositioningStateData.initial();
  }
}

// StateNotifierProvider
final positioningStateProvider =
    StateNotifierProvider<PositioningStateNotifier, PositioningStateData>((
      ref,
    ) {
      return PositioningStateNotifier();
    });
