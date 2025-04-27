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
  bool _isGuidedViewActive = false;
  bool _isLegendExpanded = false;
  double _rotationSpeed = 0.5;

  // Helper function to parse hex color string
  Color _hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void _toggleGuidedView() {
    setState(() {
      _isGuidedViewActive = !_isGuidedViewActive;
      // Reset progress and error when switching models
      _progressValue = 0.0;
      _loadError = null;
      // Note: Changing the src might require the viewer to reload.
      // Using a Key on Flutter3DViewer ensures it rebuilds.
    });
  }

  void _toggleLegend() {
    setState(() {
      _isLegendExpanded = !_isLegendExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String currentModelSrc =
        _isGuidedViewActive
            ? 'assets/models/body_colored.glb'
            : 'assets/models/body.glb';

    return Scaffold(
      backgroundColor:
          AppTheme.backgroundColor, // Or a darker theme if preferred
      appBar: AppBar(
        title: Text(
          _isGuidedViewActive ? 'Guided Skeleton' : 'Explore Skeleton',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          onPressed: () => context.go(AppRoutes.home),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: AppTheme.primaryColor.withOpacity(0.8),
            child: Flutter3DViewer(
              // Use ValueKey to force rebuild when src changes
              key: ValueKey(currentModelSrc),
              controller: _controller,
              src: currentModelSrc, // Dynamically set the model source
              enableTouch: true,
              progressBarColor: AppTheme.primaryColor,
              onProgress: (double progress) {
                // Check if the widget is still mounted before calling setState
                if (mounted) {
                  setState(() {
                    _progressValue = progress;
                    _loadError = null; // Clear error on progress
                  });
                  debugPrint('Skeleton loading progress: $progress');
                }
              },
              onLoad: (String modelAddress) {
                if (mounted) {
                  setState(() {
                    _progressValue = 1.0; // Ensure progress is 100% on load
                  });
                  debugPrint('Skeleton model loaded: $modelAddress');
                }
              },
              onError: (String error) {
                if (mounted) {
                  setState(() {
                    _loadError = error;
                    _progressValue = 0.0; // Reset progress on error
                  });
                  debugPrint('Failed to load skeleton model: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error loading model: $error\nPlease ensure the model file exists and is in the correct format.',
                      ),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 5),
                    ),
                  );
                }
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
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            )
          else if (_loadError != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700], size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load model.\nPlease check:\n1. The model file exists in assets/models/\n2. The file format is correct (.obj)\n3. The model is not corrupted',
                      style: TextStyle(color: Colors.red[700]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

          // Control Panel
          Positioned(
            top: 16,
            right: 16,
            child: Card(
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildControlButton(
                  icon:
                      _isGuidedViewActive
                          ? SolarIconsBold.eye
                          : SolarIconsOutline.eye,
                  tooltip:
                      _isGuidedViewActive
                          ? 'Show Standard View'
                          : 'Show Guided View',
                  onPressed: _toggleGuidedView,
                ),
              ),
            ),
          ),

          // Legend
          if (_isGuidedViewActive &&
              _progressValue == 1.0 &&
              _loadError == null)
            _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, color: AppTheme.primaryColor, size: 24),
          ),
        ),
      ),
    );
  }

  // Widget to build the legend
  Widget _buildLegend(BuildContext context) {
    final legendItems = {
      'Hip bone/pelvis': '#FFC8A2',
      'Ulna': '#D2E5C6',
      'Radius': '#E5C8C6', // Corrected hex code based on user input
      'Fibula': '#AAD272',
      'Cranial bone': '#EA7D70',
      'Facial bone': '#FFBF98',
    };

    return Positioned(
      bottom: 16,
      left: 16,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: _isLegendExpanded ? 200 : 48,
        child: Card(
          color: Colors.white.withOpacity(0.9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Legend Header
              InkWell(
                onTap: _toggleLegend,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isLegendExpanded
                            ? SolarIconsOutline.arrowLeft
                            : SolarIconsOutline.list,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                      if (_isLegendExpanded) ...[
                        const SizedBox(width: 8),
                        Text(
                          'Bone Legend',
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (_isLegendExpanded) ...[
                const Divider(height: 1),
                ...legendItems.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: _hexToColor(entry.value),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black54,
                              width: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.textColor),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
