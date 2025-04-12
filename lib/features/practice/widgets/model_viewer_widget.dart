import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../models/positioning_state.dart';
import '../models/collimation_state.dart';

class ModelViewerWidget extends ConsumerStatefulWidget {
  const ModelViewerWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ModelViewerWidget> createState() => _ModelViewerWidgetState();
}

class _ModelViewerWidgetState extends ConsumerState<ModelViewerWidget> {
  Flutter3DController? controller;
  bool isInitialized = false;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    controller = Flutter3DController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posState = ref.watch(positioningStateProvider);
    final colState = ref.watch(collimationStateProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isInitialized && controller != null && mounted) {
        _updateModelTransform(posState);
      }
    });

    return Stack(
      children: [
        Container(
          height: 350,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child:
                hasError
                    ? _buildErrorView()
                    : Flutter3DViewer(
                      src: 'assets/models/test.glb',
                      enableTouch: true,
                      controller: controller,
                      progressBarColor: AppTheme.primaryColor,
                      onLoad: (String modelAddress) {
                        debugPrint('Model loaded: $modelAddress');
                        if (mounted) {
                          setState(() {
                            isInitialized = true;
                            hasError = false;
                          });
                          _updateModelTransform(
                            ref.read(positioningStateProvider),
                          );
                        }
                      },
                      onProgress: (double progress) {
                        debugPrint('Loading progress: $progress');
                      },
                      onError: (error) {
                        debugPrint('Error loading model: $error');
                        if (mounted) {
                          setState(() {
                            hasError = true;
                            errorMessage = error;
                            isInitialized = false;
                          });
                        }
                      },
                    ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
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

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            'Could not load 3D model',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Using placeholder view. The interactive model could not be loaded.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _updateModelTransform(PositioningStateData state) {
    if (!isInitialized || controller == null || !mounted) return;

    try {
      controller!.setCameraOrbit(
        state.rotationY * (3.14159 / 180),
        state.rotationX * (3.14159 / 180),
        10 + state.positionZ,
      );

      controller!.setCameraTarget(state.positionX, state.positionY, 0);
    } catch (e) {
      debugPrint('Error updating model transform: $e');
    }
  }
}

class CollimationPainter extends CustomPainter {
  final double width;
  final double height;
  final double centerX;
  final double centerY;

  CollimationPainter({
    required this.width,
    required this.height,
    required this.centerX,
    required this.centerY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppTheme.primaryColor.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    final double boxWidth = size.width * width;
    final double boxHeight = size.height * height;
    final double boxLeft =
        (size.width - boxWidth) / 2 + (centerX * size.width * 0.2);
    final double boxTop =
        (size.height - boxHeight) / 2 + (centerY * size.height * 0.2);

    final rect = Rect.fromLTWH(boxLeft, boxTop, boxWidth, boxHeight);
    canvas.drawRect(rect, paint);

    final crossPaint =
        Paint()
          ..color = AppTheme.primaryColor.withOpacity(0.5)
          ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(boxLeft, boxTop + boxHeight / 2),
      Offset(boxLeft + boxWidth, boxTop + boxHeight / 2),
      crossPaint,
    );

    canvas.drawLine(
      Offset(boxLeft + boxWidth / 2, boxTop),
      Offset(boxLeft + boxWidth / 2, boxTop + boxHeight),
      crossPaint,
    );
  }

  @override
  bool shouldRepaint(CollimationPainter oldDelegate) {
    return width != oldDelegate.width ||
        height != oldDelegate.height ||
        centerX != oldDelegate.centerX ||
        centerY != oldDelegate.centerY;
  }
}
