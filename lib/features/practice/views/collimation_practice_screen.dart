import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../models/collimation_state.dart';
import '../controllers/collimation_controller.dart';
import '../widgets/collimation_controls_widget.dart';
import '../widgets/collimation_painter.dart';
import '../models/body_part.dart';
import '../models/body_region.dart';
import '../data/collimation_target_data.dart'; // Now specifically for practice
import 'package:alarp/data/repositories/practice_repository.dart';
import 'package:alarp/core/providers/supabase_providers.dart';
// Hide conflicting providers from datasource import
import 'package:alarp/data/datasources/supabase_practice_datasource.dart'
    hide recentPracticeAttemptsProvider, allPracticeAttemptsProvider;
import 'dart:developer' as developer;

// Helper function to find BodyPart (replace with better state management/repository later)
BodyPart? _findBodyPart(String regionId, String bodyPartId) {
  try {
    final region = BodyRegions.getRegionById(regionId);
    return region.bodyParts.firstWhere((part) => part.id == bodyPartId);
  } catch (e) {
    return null; // Not found
  }
}

// Helper function to find BodyRegion
BodyRegion? _findBodyRegion(String regionId) {
  try {
    return BodyRegions.getRegionById(regionId);
  } catch (e) {
    return null; // Not found
  }
}

// Define placeholder path globally or import if defined elsewhere
const String _placeholderImage = 'assets/images/alarp_icon.png';

// Convert to ConsumerStatefulWidget
class CollimationPracticeScreen extends ConsumerStatefulWidget {
  final String regionId;
  final String bodyPartId;
  final String initialProjectionName;

  const CollimationPracticeScreen({
    super.key,
    required this.regionId,
    required this.bodyPartId,
    required this.initialProjectionName,
  });

  @override
  ConsumerState<CollimationPracticeScreen> createState() =>
      _CollimationPracticeScreenState();
}

class _CollimationPracticeScreenState
    extends ConsumerState<CollimationPracticeScreen> {
  late String _selectedProjectionName;
  BodyPart? _bodyPartData;
  BodyRegion? _bodyRegionData; // Add state variable for region data
  List<String> _availableProjections = [];

  @override
  void initState() {
    super.initState();
    _selectedProjectionName = widget.initialProjectionName;
    // Fetch both body part and body region data
    _bodyPartData = _findBodyPart(widget.regionId, widget.bodyPartId);
    _bodyRegionData = _findBodyRegion(widget.regionId); // Fetch region data

    // --- Logging Start ---
    developer.log(
      'initState: regionId=${widget.regionId}, bodyPartId=${widget.bodyPartId}',
      name: 'CollimationPractice',
    );
    developer.log(
      'initState: _bodyPartData found: ${_bodyPartData != null}',
      name: 'CollimationPractice',
    );
    if (_bodyPartData != null) {
      developer.log(
        'initState: _bodyPartData title: ${_bodyPartData!.title}',
        name: 'CollimationPractice',
      );
      developer.log(
        'initState: _bodyPartData projections: ${_bodyPartData!.projections}',
        name: 'CollimationPractice',
      );
      developer.log(
        'initState: _bodyPartData imageAsset: ${_bodyPartData!.imageAsset}',
        name: 'CollimationPractice',
      );
      developer.log(
        'initState: _bodyPartData projectionImages: ${_bodyPartData!.projectionImages}',
        name: 'CollimationPractice',
      );
    }
    // --- Logging End ---

    _availableProjections =
        _bodyPartData?.projections ?? [_selectedProjectionName];
    // Ensure initial projection is valid, fallback if needed
    if (!_availableProjections.contains(_selectedProjectionName)) {
      _selectedProjectionName =
          _availableProjections.isNotEmpty
              ? _availableProjections.first
              : 'N/A';
    }
    developer.log(
      'initState: _selectedProjectionName initialized to: $_selectedProjectionName',
      name: 'CollimationPractice',
    ); // Log initial projection
  }

  // Helper to reset state, call when projection changes or reset button pressed
  void _resetCollimationState() {
    ref.read(collimationStateProvider.notifier).reset();
    // Potentially trigger controller recalculation if needed, though watching should handle it
  }

  // --- Add method to save practice attempt ---
  Future<void> _saveAttempt(
    BuildContext context,
    CollimationController controller,
  ) async {
    developer.log(
      'Attempting to save practice attempt...',
      name: 'CollimationPractice',
    );
    // No need to read userId here, repository handles it

    // Directly call repository method without creating local PracticeAttempt
    final repository = ref.read(practiceRepositoryProvider);
    final result = await repository.addPracticeAttempt(
      bodyPartId: widget.bodyPartId,
      projectionName: _selectedProjectionName,
      accuracy: controller.overallAccuracy, // Use the calculated accuracy
    );

    result.fold(
      (failure) {
        developer.log(
          'Failed to save practice attempt: ${failure.message}',
          error: failure,
          name: 'CollimationPractice',
        );
        if (mounted) {
          // Check if widget is still in the tree
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save attempt: ${failure.message}'),
            ),
          );
        }
      },
      (_) {
        developer.log(
          'Practice attempt saved successfully!',
          name: 'CollimationPractice',
        );
        if (mounted) {
          // Check if widget is still in the tree
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Practice attempt saved!')),
          );
          // Invalidate providers to refresh data (using the specific datasource providers)
          ref.invalidate(recentPracticeAttemptsProvider);
          ref.invalidate(allPracticeAttemptsProvider);
          ref.invalidate(weeklyPracticeAccuracyProvider);
          ref.invalidate(overallPracticeAccuracyProvider);
        }
      },
    );
  }
  // --- End save method ---

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch state needed for UI updates
    final colState = ref.watch(collimationStateProvider);
    // Pass selected projection and bodyPartId to the controller provider
    final params = (
      bodyPartId: widget.bodyPartId,
      projectionName: _selectedProjectionName,
    );
    final controller = ref.watch(collimationControllerProvider(params));
    // Fetch the extra target info using the practice-specific function
    final targetInfo = getPracticeTargetInfo(
      params.bodyPartId,
      params.projectionName,
    ); // Use practice getter

    // Determine image asset - Prioritize projection-specific image
    String imageAsset = _placeholderImage; // Start with placeholder
    String? projectionSpecificImage; // Variable to hold the specific path

    if (_bodyPartData != null) {
      // Check if there's a specific image for the selected projection
      projectionSpecificImage =
          _bodyPartData!.projectionImages?[_selectedProjectionName];

      if (projectionSpecificImage != null) {
        imageAsset = projectionSpecificImage;
      } else {
        // Fallback to the body part's default image if no projection-specific one exists
        imageAsset = _bodyPartData!.imageAsset;
      }
    }

    // --- Logging Start ---
    developer.log(
      'build: _selectedProjectionName: $_selectedProjectionName',
      name: 'CollimationPractice',
    );
    developer.log(
      'build: projectionSpecificImage found: $projectionSpecificImage',
      name: 'CollimationPractice',
    );
    developer.log(
      'build: Final imageAsset path: $imageAsset',
      name: 'CollimationPractice',
    );
    // --- Logging End ---

    // Use body region's background color
    final appBarColor =
        _bodyRegionData?.backgroundColor ?? AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('${_bodyPartData?.title ?? widget.bodyPartId}: Practice'),
        backgroundColor: appBarColor, // Use correct color variable
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        actions: [
          // Check Accuracy Button
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(SolarIconsOutline.checkCircle),
              tooltip: 'Check Accuracy',
              onPressed: () {
                // Pass the controller instance with the current projection
                _showResultDialog(context, controller);
                // --- Save attempt when checking accuracy ---
                _saveAttempt(context, controller);
                // --- End save attempt ---
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Add Projection Selector below AppBar
          if (_availableProjections.length > 1)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              color: appBarColor.withAlpha((255 * 0.1).round()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Projection:',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppTheme.textColor),
                  ),
                  DropdownButton<String>(
                    value: _selectedProjectionName,
                    icon: Icon(
                      SolarIconsOutline.altArrowDown,
                      size: 20,
                      color: AppTheme.primaryColor,
                    ),
                    elevation: 2,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    underline: Container(height: 0, color: Colors.transparent),
                    onChanged: (String? newValue) {
                      if (newValue != null &&
                          newValue != _selectedProjectionName) {
                        setState(() {
                          _selectedProjectionName = newValue;
                          developer.log(
                            'Dropdown changed: _selectedProjectionName set to: $_selectedProjectionName',
                            name: 'CollimationPractice',
                          ); // Log dropdown change
                        });
                        _resetCollimationState(); // Reset state on projection change
                      }
                    },
                    items:
                        _availableProjections.map<DropdownMenuItem<String>>((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Container(
                    height: 450, // Set fixed height
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            imageAsset, // Use the determined imageAsset
                            fit: BoxFit.cover, // Change fit to cover
                            errorBuilder: (context, error, stackTrace) {
                              developer.log(
                                'Image.asset errorBuilder triggered for path: $imageAsset',
                                error: error,
                                stackTrace: stackTrace,
                                name: 'CollimationPractice',
                              );
                              return Center(
                                child: Icon(
                                  SolarIconsOutline.galleryRemove,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                              );
                            },
                          ),
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: CollimationPainter(
                                  width: colState.width,
                                  height: colState.height,
                                  centerX: colState.centerX,
                                  centerY: colState.centerY,
                                  angle: colState.angle, // Pass angle
                                ),
                              ),
                            ),
                          ),
                          // Reset Button Overlay
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(
                                  (255 * 0.5).round(),
                                ),
                                borderRadius: BorderRadius.circular(
                                  20,
                                ), // Make it circular
                              ),
                              child: IconButton(
                                icon: const Icon(SolarIconsOutline.refresh),
                                color: Colors.white,
                                iconSize: 20,
                                tooltip: 'Reset Collimation',
                                onPressed:
                                    _resetCollimationState, // Call reset function
                                padding:
                                    EdgeInsets.zero, // Remove default padding
                                constraints: const BoxConstraints(
                                  // Ensure it's compact
                                  minHeight: 36,
                                  minWidth: 36,
                                ),
                              ),
                            ),
                          ),
                          // Accuracy Display Overlay
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: _getAccuracyColor(
                                  controller.collimationAccuracy,
                                ).withAlpha((255 * 0.85).round()),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(
                                      (255 * 0.2).round(),
                                    ),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    SolarIconsOutline.graphUp, // Or target icon
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${controller.collimationAccuracy.toStringAsFixed(1)}%',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // New Target Info Display Overlay
                          Positioned(
                            top:
                                52, // Position below the accuracy display (adjust as needed)
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(
                                  (255 * 0.6).round(),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(
                                    context,
                                    'IR Size:',
                                    targetInfo
                                        .irSize, // Use data from PracticeTargetInfo
                                  ),
                                  _buildInfoRow(
                                    context,
                                    'IR Orient:',
                                    targetInfo
                                        .irOrientation, // Use data from PracticeTargetInfo
                                  ),
                                  _buildInfoRow(
                                    context,
                                    'Position:',
                                    targetInfo
                                        .pxPosition, // Use data from PracticeTargetInfo
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CollimationControlsWidget(
                    // Pass params to controls widget
                    params: params,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Update _showResultDialog to accept the controller directly
  void _showResultDialog(
    BuildContext context,
    CollimationController controller,
  ) {
    final isCorrect = controller.isCorrect;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              isCorrect ? 'Correctly Collimated!' : 'Not Quite Right',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isCorrect ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCorrect
                      ? SolarIconsBold.checkCircle
                      : SolarIconsBold.infoCircle,
                  color: isCorrect ? Colors.green : Colors.orange,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  isCorrect
                      ? 'Great job! Your collimation is correct.'
                      : 'Your collimation needs some adjustments.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildAccuracyRow(
                  context,
                  label: 'Collimation Accuracy',
                  value: controller.collimationAccuracy,
                ),
                const Divider(height: 24),
                _buildAccuracyRow(
                  context,
                  label: 'Overall Accuracy',
                  value: controller.overallAccuracy,
                  isTotal: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(isCorrect ? 'Continue' : 'Try Again'),
              ),
            ],
          ),
    );
  }

  // _buildAccuracyRow remains the same
  Widget _buildAccuracyRow(
    BuildContext context, {
    required String label,
    required double value,
    bool isTotal = false,
  }) {
    Color color;
    // Update threshold to 90
    if (value >= 90) {
      color = Colors.green;
    } else if (value >= 70) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.w600 : null,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha((255 * 0.1).round()),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${value.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget to build info rows for the new overlay
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Keep row compact
        children: [
          Text(
            '$label ',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white70, // Lighter color for label
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Add _getAccuracyColor helper (can be moved to a utility file later)
  Color _getAccuracyColor(double accuracy) {
    // Update threshold to 98
    if (accuracy >= 90) return Colors.green;
    if (accuracy >= 70) return Colors.orange;
    return Colors.red;
  }
}
