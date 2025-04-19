import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:alarp/core/theme/app_theme.dart';

class LearnModelViewer extends StatefulWidget {
  final String src; // Path to the model file

  // Use super parameters for key
  const LearnModelViewer({super.key, required this.src});

  @override
  State<LearnModelViewer> createState() => _LearnModelViewerState();
}

class _LearnModelViewerState extends State<LearnModelViewer> {
  // Controller reference (optional for Learn, but can be useful)
  final Flutter3DController controller = Flutter3DController();
  bool isInitialized = false;
  bool hasError = false;
  String errorMessage = '';

  @override
  void dispose() {
    // Dispose the controller to release resources - Removed as Flutter3DController has no dispose method
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No external state dependencies needed for Learn view

    return Container(
      // Using AspectRatio from the lesson screen's _buildMediaContainer
      // height: 350, // Height is controlled by AspectRatio in parent
      decoration: BoxDecoration(
        // Make background much lighter or transparent
        // Replace deprecated withOpacity
        color: AppTheme.primaryColor.withAlpha((255 * 0.8).round()),
        borderRadius: BorderRadius.circular(12), // Match parent ClipRRect
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            hasError
                ? _buildErrorView()
                : Flutter3DViewer(
                  // Use the src passed to the widget
                  src: widget.src,
                  // Allow user interaction for exploration
                  enableTouch: true,
                  controller: controller,
                  // Intercept gestures if needed, true allows viewer to handle gestures
                  // Set to false if parent ScrollView should handle vertical drags primarily
                  // activeGestureInterceptor: true,
                  progressBarColor: AppTheme.secondaryColor,
                  onLoad: (String modelAddress) {
                    debugPrint('Learn Model loaded: $modelAddress');
                    if (mounted) {
                      setState(() {
                        isInitialized = true;
                        hasError = false;
                      });
                    }
                    // Optional: Set initial camera angle if desired
                    // controller?.setCameraOrbit(0, 30, 5);
                  },
                  onProgress: (double progress) {
                    // Optional: Could show progress indicator if needed
                    debugPrint('Loading progress: $progress');
                  },
                  onError: (error) {
                    debugPrint('Error loading model: $error');
                    if (mounted) {
                      setState(() {
                        hasError = true;
                        errorMessage = error;
                      });
                    }
                  },
                ),
      ),
    );
    // Removed Stack and CollimationPainter as they are not needed here
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            'Could not load 3D model',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'The interactive model (${widget.src}) could not be loaded. $errorMessage',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  // Removed _updateModelTransform as it depended on external state
}
