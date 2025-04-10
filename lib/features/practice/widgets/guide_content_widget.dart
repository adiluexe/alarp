// guide_content_widget.dart
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/theme/app_theme.dart';

class GuideContentWidget extends StatelessWidget {
  const GuideContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Positioning Guide',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            _buildGuideItem(
              context,
              title: 'Body Position',
              icon: SolarIconsOutline.undoRightRound,
              content:
                  'Adjust the rotation sliders to position the body part. '
                  'For AP projections, ensure the body part is facing the detector directly.',
            ),

            _buildGuideItem(
              context,
              title: 'Collimation',
              icon: SolarIconsOutline.cropMinimalistic,
              content:
                  'Collimation should only include the relevant anatomy. '
                  'Adjust the field size to restrict radiation to the area of interest.',
            ),

            _buildGuideItem(
              context,
              title: 'Centering',
              icon: SolarIconsOutline.target,
              content:
                  'The central ray (center of the collimation field) should '
                  'be aligned with the center of the anatomical structure being imaged.',
            ),

            // Specific information for the current projection would go here
            // This would be populated based on the selected body part
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        SolarIconsOutline.infoSquare,
                        color: AppTheme.primaryColor,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Target Parameters',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rotation: AP (0°, 0°, 0°)\n'
                    'Collimation: Medium field (0.6 x 0.6)\n'
                    'Centering: Central to anatomy',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(content, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
