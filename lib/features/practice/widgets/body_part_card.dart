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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
            // Content section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        bodyPart.projections.map((projection) {
                          return Chip(
                            label: Text(
                              projection,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: AppTheme.primaryColor),
                            ),
                            backgroundColor: AppTheme.primaryColor.withOpacity(
                              0.1,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Icon(
                SolarIconsOutline.altArrowRight,
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
