import 'package:flutter/material.dart';
import 'package:alarp/core/theme/app_theme.dart';

class LearningProgressChart extends StatelessWidget {
  const LearningProgressChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data for the chart
    final List<double> weeklyData = [65, 72, 78, 65, 81, 75, 85];
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              return _buildBar(context, weeklyData[index], days[index]);
            }),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(
              context,
              AppTheme.primaryColor,
              'Practice Accuracy',
            ),
            const SizedBox(width: 16),
            _buildLegendItem(
              context,
              AppTheme.secondaryColor,
              'Challenge Score',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBar(BuildContext context, double value, String day) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: (value / 100) * 140, // Convert percentage to height
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.secondaryColor, AppTheme.primaryColor],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
