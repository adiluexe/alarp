import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';

class StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit; // Make unit optional
  final IconData icon;
  final Color color;

  const StatsCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardColor = color.withOpacity(0.1); // Background tint
    final iconColor = color; // Icon color
    final valueColor = AppTheme.textColor; // Use default text color for value
    final labelColor = AppTheme.textColor.withOpacity(0.7); // Dimmer label

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(color: labelColor),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.baseline, // Align baseline of value and unit
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                  height: 1.1, // Adjust line height if needed
                ),
              ),
              if (unit != null && unit!.isNotEmpty) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 2.0,
                  ), // Fine-tune baseline alignment
                  child: Text(
                    unit!,
                    style: textTheme.bodySmall?.copyWith(color: labelColor),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
