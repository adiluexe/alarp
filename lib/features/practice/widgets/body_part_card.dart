import 'package:flutter/material.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/practice/models/body_part.dart';
import 'package:solar_icons/solar_icons.dart';

class BodyPartCard extends StatelessWidget {
  final BodyPart bodyPart;
  final VoidCallback onTap;

  const BodyPartCard({Key? key, required this.bodyPart, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image section
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  bodyPart.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback for missing images
                    return Container(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          SolarIconsOutline.bones,
                          color: AppTheme.primaryColor,
                          size: 32,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Content section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bodyPart.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bodyPart.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          bodyPart.projections.map((projection) {
                            return Chip(
                              label: Text(
                                projection,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: AppTheme.primaryColor),
                              ),
                              backgroundColor: AppTheme.primaryColor
                                  .withOpacity(0.1),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Arrow icon
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey[400],
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
