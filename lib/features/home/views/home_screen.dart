import 'package:alarp/core/widgets/action_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/core/navigation/app_router.dart';
import 'package:alarp/features/challenge/models/challenge.dart';
import 'package:alarp/core/providers/supabase_providers.dart'; // Import the profile provider
import 'package:alarp/data/repositories/practice_repository.dart'; // Import practice providers
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'package:alarp/features/practice/models/practice_attempt.dart'; // Import PracticeAttempt
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the user profile provider
    final userProfileAsync = ref.watch(userProfileProvider);
    // Watch the weekly accuracy provider
    final weeklyAccuracyAsync = ref.watch(weeklyAccuracyProvider);
    // Watch all practice attempts for the chart
    final allPracticeAttemptsAsync = ref.watch(allPracticeAttemptsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pass user profile data to header and stats
              userProfileAsync.when(
                data: (profileData) {
                  // Extract first name, fallback to username or 'User'
                  final firstName = profileData?['first_name'] as String?;
                  final userName =
                      profileData?['username'] as String? ?? 'User';
                  final displayFirstName =
                      (firstName != null && firstName.isNotEmpty)
                          ? firstName
                          : userName;

                  final streakDays =
                      profileData?['current_streak'] as int? ?? 0;
                  final completedLessons =
                      0; // TODO: Fetch actual completed lessons
                  final totalLessons = 36; // TODO: Fetch actual total lessons
                  // Use the fetched weekly accuracy, default to 0.0 if loading/error
                  final weeklyAccuracy = weeklyAccuracyAsync.value ?? 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(
                        context,
                        displayFirstName,
                        streakDays,
                      ), // Pass first name
                      const SizedBox(height: 24),
                      _buildStats(
                        context,
                        completedLessons,
                        totalLessons,
                        weeklyAccuracy,
                      ),
                    ],
                  );
                },
                loading:
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, 'Loading...', 0),
                        const SizedBox(height: 24),
                        // Pass 0.0 during loading
                        _buildStats(context, 0, 0, 0.0),
                      ],
                    ),
                error:
                    (error, stack) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, 'Error', 0),
                        const SizedBox(height: 24),
                        // Pass 0.0 on error, maybe show error message elsewhere
                        _buildStats(context, 0, 0, 0.0),
                        Center(child: Text('Error loading profile: $error')),
                      ],
                    ),
              ),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildSkeletonExplorer(context),
              const SizedBox(height: 24),
              // Pass practice attempts data to the learning progress section
              _buildLearningProgress(context, allPracticeAttemptsAsync),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String firstName, int streakDays) {
    // Changed userName to firstName
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
      children: [
        // Wrap the name column in Expanded to handle long names
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textColor.withAlpha((0.7 * 255).round()),
                ),
              ),
              Text(
                firstName, // Use passed first name
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontFamily: 'Chillax',
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1, // Ensure name stays on one line
                overflow: TextOverflow.ellipsis, // Add ellipsis for long names
              ),
            ],
          ),
        ),
        const SizedBox(width: 16), // Add spacing between name and streak
        // Streak indicator (no changes needed here)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withAlpha((0.1 * 255).round()),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(SolarIconsBold.fire, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 6),
              Text(
                '$streakDays day streak',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final String dailyChallengeId = Challenge.upperExtremitiesChallenge.id;
    const double cardWidth = 280.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          clipBehavior: Clip.none,
          child: IntrinsicHeight(
            child: Row(
              children: [
                SizedBox(
                  width: cardWidth,
                  child: ActionCard(
                    title: 'Continue Learning',
                    subtitle: 'AP Chest Projection',
                    description: 'Continue where you left off',
                    icon: SolarIconsBold.bookBookmark,
                    color: AppTheme.primaryColor,
                    onTap: () {
                      context.go(AppRoutes.learn);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: cardWidth,
                  child: ActionCard(
                    title: 'Daily Challenge',
                    subtitle: 'Upper Extremities',
                    description: 'Complete today\'s challenge',
                    icon: SolarIconsBold.medalStar,
                    color: AppTheme.secondaryColor,
                    onTap: () {
                      context.push(
                        AppRoutes.challengeStartRoute(dailyChallengeId),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: cardWidth,
                  child: ActionCard(
                    title: 'Practice Session',
                    subtitle: 'Hands-on positioning',
                    description: 'Practice your skills',
                    icon: SolarIconsBold.compassSquare,
                    color: AppTheme.accentColor,
                    onTap: () {
                      context.go(AppRoutes.practice);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStats(
    BuildContext context,
    int completedLessons,
    int totalLessons,
    double weeklyAccuracy,
  ) {
    final statsGradient = LinearGradient(
      colors: [
        AppTheme.primaryColor.withAlpha((0.8 * 255).round()),
        AppTheme.secondaryColor.withAlpha((0.7 * 255).round()),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
    const Color contentColor = Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: statsGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withAlpha((0.3 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: contentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(
                context,
                'Completed',
                '$completedLessons/$totalLessons',
                'lessons',
                SolarIconsBold.diploma,
                contentColor,
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                context,
                'Accuracy',
                '${weeklyAccuracy.toStringAsFixed(1)}%',
                'this week',
                SolarIconsBold.target,
                contentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    String sublabel,
    IconData icon,
    Color contentColor,
  ) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.2 * 255).round()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: contentColor, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: contentColor.withAlpha((0.8 * 255).round()),
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: contentColor,
                ),
              ),
              Text(
                sublabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: contentColor.withAlpha((0.8 * 255).round()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonExplorer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Anatomy Explorer', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ActionCard(
          title: '3D Skeleton Viewer',
          subtitle: 'Interactive anatomical model',
          description: 'Study bones and landmarks in detail',
          icon: SolarIconsBold.bone,
          color: AppTheme.primaryColor,
          onTap: () {
            context.go(AppRoutes.skeletonViewer);
          },
        ),
      ],
    );
  }

  Widget _buildLearningProgress(
    BuildContext context,
    AsyncValue<List<PracticeAttempt>> attemptsAsync,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = AppTheme.primaryColor;
    final secondaryColor = AppTheme.secondaryColor;
    final dateFormat =
        DateFormat.Md(); // Use a concise date format (e.g., '4/23')

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Practice Progress', style: textTheme.titleLarge),
        const SizedBox(height: 16),
        Container(
          height: 220, // Increased height slightly for better visibility
          padding: const EdgeInsets.fromLTRB(12, 20, 16, 12), // Adjust padding
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.05 * 255).round()),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          // Use AsyncValue.when to handle loading/error/data states
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

              // Sort attempts by date (oldest first) for the chart
              final sortedAttempts = List<PracticeAttempt>.from(attempts)
                ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

              // Prepare data points (FlSpot)
              final spots =
                  sortedAttempts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final attempt = entry.value;
                    return FlSpot(index.toDouble(), attempt.accuracy);
                  }).toList();

              // Determine a reasonable interval for date labels
              double bottomTitleInterval = 1;
              if (spots.length > 5) {
                // Aim for roughly 5-7 labels
                bottomTitleInterval = (spots.length / 6).ceilToDouble();
              }

              return LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 105, // Slightly above 100 for padding
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false, // Hide vertical grid lines
                    horizontalInterval: 25, // Grid lines every 25%
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    // Hide top and right titles
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    // Configure bottom titles (attempt number or date)
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval:
                            bottomTitleInterval, // Use calculated interval
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < sortedAttempts.length) {
                            // Show labels based on the calculated interval
                            if (index % bottomTitleInterval.toInt() == 0 ||
                                index == spots.length - 1 ||
                                index == 0) {
                              final attempt = sortedAttempts[index];
                              return SideTitleWidget(
                                meta: meta,
                                space: 8.0,
                                child: Text(
                                  dateFormat.format(
                                    attempt.createdAt.toLocal(),
                                  ), // Format date
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
                    ),
                    // Configure left titles (accuracy percentage)
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 25, // Show 0, 25, 50, 75, 100
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
                        show:
                            spots.length <
                            20, // Show dots only for fewer points
                        getDotPainter:
                            (spot, percent, barData, index) =>
                                FlDotCirclePainter(
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
                            primaryColor.withAlpha((0.3 * 255).round()),
                            secondaryColor.withAlpha((0.1 * 255).round()),
                            secondaryColor.withAlpha((0.0 * 255).round()),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  // Tooltip customization
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor:
                          (spot) => Colors.blueGrey.shade800.withAlpha(
                            (0.9 * 255).round(),
                          ),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final index = touchedSpot.spotIndex;
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
                        }).toList();
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
        ),
      ],
    );
  }
}

// Helper function to capitalize (assuming it's defined elsewhere or copy it here if needed)
String _capitalize(String s) {
  if (s.isEmpty) return s;
  // Simple capitalization for example, adjust as needed
  return s
      .split(' ')
      .map((word) {
        if (word.isEmpty) return '';
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      })
      .join(' ');
}
