import 'package:flutter/foundation.dart';
import '../../practice/models/collimation_state.dart'; // Assuming CollimationStateData is here

@immutable
class Projection {
  final String name;
  final String imageUrl;
  final CollimationStateData? targetCollimation;
  // Add other relevant fields if needed, e.g., description, steps

  const Projection({
    required this.name,
    required this.imageUrl,
    this.targetCollimation,
    // Initialize other fields
  });

  // Optional: Add copyWith, toJson, fromJson if needed later
}
