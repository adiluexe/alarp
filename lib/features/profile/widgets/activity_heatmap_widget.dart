import 'package:flutter/material.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class ActivityHeatmapWidget extends StatelessWidget {
  final Map<DateTime, int> activityData;
  final DateTime endDate;
  final int daysToShow;

  const ActivityHeatmapWidget({
    super.key,
    required this.activityData,
    required this.endDate,
    this.daysToShow = 90, // Show last 3 months approx
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Activity', style: Theme.of(context).textTheme.titleLarge),
            Text(
              'Last 90 Days',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate number of columns that fit
              // 7 rows, aspect ratio 1.0, spacing 4
              // width = (size * cols) + (spacing * (cols - 1))
              // Let's try to fit 13 weeks (91 days) which is standard quarter
              const int columns = 13;

              return GridView.builder(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 1.0,
                ),
                itemCount: columns * 7, // 91 days
                itemBuilder: (context, index) {
                  // We want to show the LAST 91 days.
                  // So we need to offset the date calculation.
                  // index 0 is top-left.
                  // Usually heatmaps go column by column, left to right.
                  // So index 0 is (StartDate), index 1 is (StartDate + 1) ?? No, usually column major?
                  // GridView defaults to row major (fill row then next).
                  // Horizontal GridView fills column then next column?
                  // "In a horizontal GridView, items are positioned in columns."
                  // So index 0, 1, 2... 6 are the first column.
                  // This matches the week structure (Sun-Sat).

                  final date = endDate.subtract(
                    Duration(days: (columns * 7) - 1 - index),
                  );
                  final activityLevel =
                      activityData[DateUtils.dateOnly(date)] ?? 0;

                  return _buildDayBox(context, date, activityLevel);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Less', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(width: 4),
            _buildLegendBox(Colors.grey[200]!),
            const SizedBox(width: 2),
            _buildLegendBox(AppTheme.primaryColor.withOpacity(0.3)),
            const SizedBox(width: 2),
            _buildLegendBox(AppTheme.primaryColor.withOpacity(0.6)),
            const SizedBox(width: 2),
            _buildLegendBox(AppTheme.primaryColor),
            const SizedBox(width: 4),
            Text('More', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildDayBox(BuildContext context, DateTime date, int level) {
    Color color;
    if (level == 0) {
      color = Colors.grey[200]!;
    } else if (level < 3) {
      color = AppTheme.primaryColor.withOpacity(0.3);
    } else if (level < 6) {
      color = AppTheme.primaryColor.withOpacity(0.6);
    } else {
      color = AppTheme.primaryColor;
    }

    return Tooltip(
      message: '${DateFormat.yMMMd().format(date)}: $level activities',
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
