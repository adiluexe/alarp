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

  const CollimationStateData({
    this.width = 0.5, // Default width
    this.height = 0.5, // Default height
    this.centerX = 0.0, // Default center X
    this.centerY = 0.0, // Default center Y
  });

  // Initial state
  factory CollimationStateData.initial() => const CollimationStateData();

  // CopyWith method for immutability
  CollimationStateData copyWith({
    double? width,
    double? height,
    double? centerX,
    double? centerY,
  }) {
    return CollimationStateData(
      width: width ?? this.width,
      height: height ?? this.height,
      centerX: centerX ?? this.centerX,
      centerY: centerY ?? this.centerY,
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
          centerY == other.centerY;

  @override
  int get hashCode =>
      width.hashCode ^ height.hashCode ^ centerX.hashCode ^ centerY.hashCode;
}

// StateNotifier class
class CollimationStateNotifier extends StateNotifier<CollimationStateData> {
  CollimationStateNotifier() : super(CollimationStateData.initial());

  void updateSize({double? newWidth, double? newHeight}) {
    state = state.copyWith(
      width: newWidth ?? state.width,
      height: newHeight ?? state.height,
    );
  }

  void updateCrossPosition({double? x, double? y}) {
    state = state.copyWith(
      centerX: x ?? state.centerX,
      centerY: y ?? state.centerY,
    );
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
