import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:alarp/features/practice/models/practice_attempt.dart';
import 'package:alarp/core/theme/app_theme.dart';

// Helper function to capitalize (adjust as needed based on your project structure)
String _capitalize(String s) {
  if (s.isEmpty) return s;
  return s
      .split(' ')
      .map((word) {
        if (word.isEmpty) return '';
        // Handle words starting with '(' - keep '(' and capitalize next letter
        if (word.startsWith('(') && word.length > 1) {
          return '(${word[1].toUpperCase()}${word.substring(2).toLowerCase()}';
        }
        // Standard capitalization
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      })
      .join(' ');
}

class PracticeAccuracyChart extends ConsumerWidget {
  final AsyncValue<List<PracticeAttempt>> attemptsAsync;

  const PracticeAccuracyChart({required this.attemptsAsync, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = AppTheme.primaryColor;
    final secondaryColor = AppTheme.secondaryColor;

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(12, 20, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(
              (0.05 * 255).round(),
            ), // Fixed withAlpha
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: attemptsAsync.when(
        data: (attempts) {
          if (attempts.isEmpty) {
            return Center(
              child: Text(
                'No practice data available yet.',
                style: textTheme.bodyMedium,
              ),
            );
          }

          final sortedAttempts = List<PracticeAttempt>.from(attempts)
            ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

          final spots =
              sortedAttempts.asMap().entries.map((entry) {
                final index = entry.key;
                final attempt = entry.value;
                return FlSpot(index.toDouble(), attempt.accuracy);
              }).toList();

          return LineChart(
            LineChartData(
              minY: 0,
              maxY: 105,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 25,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: Colors.grey.shade300, strokeWidth: 0.5);
                },
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval:
                        spots.length > 10
                            ? (spots.length / 5).floorToDouble()
                            : 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < spots.length) {
                        if (meta.max == value ||
                            meta.min == value ||
                            index % meta.appliedInterval.toInt() == 0) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 8.0,
                            child: Text(
                              (index + 1).toString(),
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  axisNameWidget: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Attempt Number', style: textTheme.labelSmall),
                  ),
                  axisNameSize: 30,
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 25,
                    getTitlesWidget: (value, meta) {
                      if (value == 0 ||
                          value == 25 ||
                          value == 50 ||
                          value == 75 ||
                          value == 100) {
                        return SideTitleWidget(
                          meta: meta,
                          space: 8.0,
                          child: Text(
                            '${value.toInt()}%',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  axisNameWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('Accuracy', style: textTheme.labelSmall),
                  ),
                  axisNameSize: 20,
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  left: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                  ),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: spots.length < 20,
                    getDotPainter:
                        (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 3,
                          color:
                              Color.lerp(
                                primaryColor,
                                secondaryColor,
                                spot.x / spots.length,
                              ) ??
                              primaryColor,
                          strokeWidth: 1,
                          strokeColor: Colors.white,
                        ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        primaryColor.withAlpha(
                          (0.3 * 255).round(),
                        ), // Fixed withAlpha
                        secondaryColor.withAlpha(
                          (0.1 * 255).round(),
                        ), // Fixed withAlpha
                        secondaryColor.withAlpha(
                          (0.0 * 255).round(),
                        ), // Fixed withAlpha
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor:
                      (spot) => Colors.blueGrey.shade800.withAlpha(
                        (0.9 * 255).round(),
                      ), // Fixed getTooltipColor
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots
                        .map((LineBarSpot touchedSpot) {
                          final index = touchedSpot.spotIndex;
                          if (index < 0 || index >= sortedAttempts.length) {
                            return null; // Avoid index out of bounds
                          }
                          final attempt = sortedAttempts[index];
                          final dateStr = DateFormat.yMd().add_jm().format(
                            attempt.createdAt.toLocal(),
                          );
                          return LineTooltipItem(
                            '${touchedSpot.y.toStringAsFixed(1)}%\n',
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${_capitalize(attempt.bodyPartId)} - ${attempt.projectionName}\n',
                                style: TextStyle(
                                  color: Colors.grey.shade300,
                                  fontSize: 10,
                                ),
                              ),
                              TextSpan(
                                text: dateStr,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                            textAlign: TextAlign.left,
                          );
                        })
                        .whereType<LineTooltipItem>()
                        .toList(); // Filter out nulls
                  },
                ),
                handleBuiltInTouches: true,
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Text(
                'Could not load practice data: $error',
                style: textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
            ),
      ),
    );
  }
}
