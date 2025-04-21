import 'package:flutter/foundation.dart';
import '../../practice/models/collimation_state.dart'; // Assuming CollimationStateData is here

@immutable
class Projection {
  final String name;
  final String imageUrl;
  final CollimationStateData? targetCollimation;
  final String? irSize; // Added
  final String? irOrientation; // Added
  final String? pxPosition; // Added

  const Projection({
    required this.name,
    required this.imageUrl,
    this.targetCollimation,
    this.irSize, // Added
    this.irOrientation, // Added
    this.pxPosition, // Added
  });

  // Optional: Add copyWith, toJson, fromJson if needed later
}
