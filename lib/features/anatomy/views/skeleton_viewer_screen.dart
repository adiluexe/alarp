import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes

class SkeletonViewerScreen extends StatefulWidget {
  const SkeletonViewerScreen({super.key});

  @override
  State<SkeletonViewerScreen> createState() => _SkeletonViewerScreenState();
}

class _SkeletonViewerScreenState extends State<SkeletonViewerScreen> {
  final Flutter3DController _controller = Flutter3DController();
  double _progressValue = 0.0;
  String? _loadError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppTheme.backgroundColor, // Or a darker theme if preferred
      appBar: AppBar(
        title: const Text('Explore Skeleton'),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          // Change from pop to go to the home route
          onPressed: () => context.go(AppRoutes.home),
        ),
        // Add flexibleSpace for the gradient
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.secondaryColor, // Example gradient
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Wrap the viewer in a Container to set the background color
          Container(
            color: AppTheme.accentColor.withOpacity(
              0.5,
            ), // Set the background color with opacity
            child: Flutter3DViewer(
              // Controller is needed for potential future interactions (animations, etc.)
              controller: _controller,
              // Path to your GLB model asset
              src: 'assets/models/body.glb',
              // Enable touch interactions (zoom, pan, rotate) - default is true
              enableTouch: true,
              // Optional: Set camera defaults if needed
              // cameraTarget: CameraTarget(0, 0.8, 0), // Example target
              // cameraOrbit: CameraOrbit(0, 90, 5), // Example orbit
              // Show a progress indicator while loading
              progressBarColor: AppTheme.primaryColor,
              onProgress: (double progress) {
                setState(() {
                  _progressValue = progress;
                  _loadError = null; // Clear error on progress
                });
                debugPrint('Skeleton loading progress: $progress');
              },
              onLoad: (String modelAddress) {
                setState(() {
                  _progressValue = 1.0; // Ensure progress is 100% on load
                });
                debugPrint('Skeleton model loaded: $modelAddress');
              },
              onError: (String error) {
                setState(() {
                  _loadError = error;
                });
                debugPrint('Failed to load skeleton model: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error loading model: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          ),
          // Show loading indicator or error message
          if (_progressValue < 1.0 && _loadError == null)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    value: _progressValue > 0 ? _progressValue : null,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading Skeleton...',
                    style: TextStyle(color: AppTheme.textColor),
                  ),
                ],
              ),
            )
          else if (_loadError != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Failed to load model.\nPlease check the asset path and format.',
                  style: TextStyle(color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
