import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/core/navigation/app_router.dart';
import 'package:alarp/features/challenge/models/challenge.dart';
import 'package:alarp/core/providers/supabase_providers.dart';
import 'package:alarp/data/repositories/practice_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:alarp/features/practice/models/practice_attempt.dart';
import 'package:intl/intl.dart';
import 'package:alarp/features/home/widgets/daily_challenge_card.dart';
import 'package:alarp/features/home/widgets/anatomy_fact_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final weeklyAccuracyAsync = ref.watch(weeklyAccuracyProvider);
    final allPracticeAttemptsAsync = ref.watch(allPracticeAttemptsProvider);
    final dailyChallengeId = Challenge.upperExtremitiesChallenge.id;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              userProfileAsync.when(
                data: (profileData) {
                  final firstName = profileData?['first_name'] as String?;
                  final userName =
                      profileData?['username'] as String? ?? 'User';
                  final displayFirstName =
                      (firstName != null && firstName.isNotEmpty)
                          ? firstName
                          : userName;
                  final streakDays =
                      profileData?['current_streak'] as int? ?? 0;
                  return _buildHeader(
                    context,
                    displayFirstName,
                    streakDays,
                  );
                },
                loading: () => _buildHeaderShimmer(context),
                error: (error, stack) =>
                    _buildHeader(context, 'User', 0),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 24),

              // Hero Daily Challenge
              DailyChallengeCard(challengeId: dailyChallengeId)
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms)
                  .slideY(begin: 0.05, end: 0),

              const SizedBox(height: 24),

              // Quick Actions Grid
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
              const SizedBox(height: 16),
              _buildQuickActionsGrid(context)
                  .animate()
                  .fadeIn(delay: 250.ms, duration: 400.ms)
                  .slideY(begin: 0.05, end: 0),

              const SizedBox(height: 24),

              // Stats Overview
              userProfileAsync.when(
                data: (profileData) {
                  final completedLessons = 0; // TODO: Fetch actual
                  final totalLessons = 36; // TODO: Fetch actual
                  final weeklyAccuracy = weeklyAccuracyAsync.value ?? 0.0;
                  return _buildStats(
                    context,
                    completedLessons,
                    totalLessons,
                    weeklyAccuracy,
                  );
                },
                loading: () => _buildStatsShimmer(context),
                error: (e, s) => _buildStats(context, 0, 0, 0.0),
              )
                  .animate()
                  .fadeIn(delay: 350.ms, duration: 400.ms)
                  .slideY(begin: 0.05, end: 0),

              const SizedBox(height: 24),

              // Anatomy Fact
              const AnatomyFactCard()
                  .animate()
                  .fadeIn(delay: 450.ms, duration: 400.ms),

              const SizedBox(height: 24),

              // Learning Progress Chart
              _buildLearningProgress(context, allPracticeAttemptsAsync)
                  .animate()
                  .fadeIn(delay: 550.ms, duration: 400.ms),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    String firstName,
    int streakDays,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textColor.withOpacity(0.7),
              ),
            ),
            Text(
              firstName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontFamily: 'Chillax',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: streakDays > 0
                  ? Colors.orange.withOpacity(0.12)
                  : AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: streakDays > 0
                    ? Colors.orange.withOpacity(0.3)
                    : AppTheme.primaryColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  SolarIconsBold.fire,
                  color: streakDays > 0
                      ? Colors.orange.shade600
                      : AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  '$streakDays',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: streakDays > 0
                        ? Colors.orange.shade600
                        : AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 140,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          Container(
            width: 72,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildGridActionCard(
          context,
          title: 'Learn',
          icon: SolarIconsBold.bookBookmark,
          color: AppTheme.primaryColor,
          onTap: () {
            HapticFeedback.lightImpact();
            context.go(AppRoutes.learn);
          },
        ),
        _buildGridActionCard(
          context,
          title: 'Practice',
          icon: SolarIconsBold.compassSquare,
          color: AppTheme.accentColor,
          onTap: () {
            HapticFeedback.lightImpact();
            context.go(AppRoutes.practice);
          },
        ),
        _buildGridActionCard(
          context,
          title: 'Flashcards',
          icon: SolarIconsBold.card,
          color: Colors.orange,
          onTap: () {
            HapticFeedback.lightImpact();
            context.push(AppRoutes.flashcards);
          },
        ),
        _buildGridActionCard(
          context,
          title: 'Leaderboard',
          icon: SolarIconsBold.cup,
          color: Colors.purple,
          onTap: () {
            HapticFeedback.lightImpact();
            context.push(AppRoutes.leaderboard);
          },
        ),
      ],
    );
  }

  Widget _buildGridActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats(
    BuildContext context,
    int completedLessons,
    int totalLessons,
    double weeklyAccuracy,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              context,
              'Lessons',
              '$completedLessons/$totalLessons',
              SolarIconsBold.diploma,
              AppTheme.primaryColor,
            ),
          ),
          Container(width: 1, height: 40, color: AppTheme.borderColor),
          Expanded(
            child: _buildStatItem(
              context,
              'Accuracy',
              '${weeklyAccuracy.toStringAsFixed(0)}%',
              SolarIconsBold.target,
              AppTheme.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textColor.withOpacity(0.6),
          ),
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
    final dateFormat = DateFormat.Md();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Practice Progress', style: textTheme.titleLarge),
        const SizedBox(height: 16),
        Container(
          height: 220,
          padding: const EdgeInsets.fromLTRB(12, 20, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: attemptsAsync.when(
            data: (attempts) {
              if (attempts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        SolarIconsOutline.chartSquare,
                        size: 40,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No practice data yet.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Start practicing to see your progress here.',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              final sortedAttempts = List<PracticeAttempt>.from(attempts)
                ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

              final spots = sortedAttempts.asMap().entries.map((entry) {
                final index = entry.key;
                final attempt = entry.value;
                return FlSpot(index.toDouble(), attempt.accuracy);
              }).toList();

              double bottomTitleInterval = 1;
              if (spots.length > 5) {
                bottomTitleInterval = (spots.length / 6).ceilToDouble();
              }

              return LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 105,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 25,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
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
                        interval: bottomTitleInterval,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < sortedAttempts.length) {
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
                                  ),
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
                                  fontSize: 10,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: spots.length < 20,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: primaryColor,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.2),
                            primaryColor.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            error: (error, stack) => Center(
              child: Text(
                'Could not load practice data',
                style: textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
