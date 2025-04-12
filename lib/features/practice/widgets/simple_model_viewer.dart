import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Add riverpod import
import '../../../core/theme/app_theme.dart';
// Import providers
import '../models/positioning_state.dart';
import '../models/collimation_state.dart';
// Import the painter from the other file to avoid duplication
import 'model_viewer_widget.dart' show CollimationPainter;

// Change to ConsumerWidget
class SimpleModelViewer extends ConsumerWidget {
  const SimpleModelViewer({Key? key}) : super(key: key);

  @override
  // Add WidgetRef ref
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state providers
    final posState = ref.watch(positioningStateProvider);
    final colState = ref.watch(collimationStateProvider);

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
                      // Use watched state
                      ..rotateX(posState.rotationX * 3.14159 / 180)
                      ..rotateY(posState.rotationY * 3.14159 / 180)
                      ..rotateZ(posState.rotationZ * 3.14159 / 180)
                      ..scale(posState.scale),
                alignment: Alignment.center,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    // Use theme color if available, otherwise fallback
                    color: AppTheme.accentColor ?? AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Center(
                    // Make child const
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
              // Use watched state
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
