import 'package:flutter/material.dart';
import 'package:alarp/core/theme/app_theme.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Learning Path',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontFamily: 'Chillax',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Study radiographic positioning by body regions',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Body regions grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildListDelegate([
                  _buildBodyRegionCard(
                    context,
                    title: 'Head & Neck',
                    emoji: '🧠',
                    totalPositions: 18,
                    completedPositions: 5,
                    color: const Color(0xFFEB6B9D),
                  ),
                  _buildBodyRegionCard(
                    context,
                    title: 'Thorax',
                    emoji: '🫁',
                    totalPositions: 12,
                    completedPositions: 0,
                    color: const Color(0xFF5B93EB),
                  ),
                  _buildBodyRegionCard(
                    context,
                    title: 'Abdomen & Pelvis',
                    emoji: '🧍‍♂️',
                    totalPositions: 15,
                    completedPositions: 0,
                    color: const Color(0xFF53C892),
                  ),
                  _buildBodyRegionCard(
                    context,
                    title: 'Upper Extremity',
                    emoji: '💪',
                    totalPositions: 20,
                    completedPositions: 0,
                    color: const Color(0xFFFFAA33),
                  ),
                  _buildBodyRegionCard(
                    context,
                    title: 'Lower Extremity',
                    emoji: '🦵',
                    totalPositions: 22,
                    completedPositions: 0,
                    color: const Color(0xFF9474DE),
                  ),
                  _buildBodyRegionCard(
                    context,
                    title: 'Spine',
                    emoji: '🦴',
                    totalPositions: 14,
                    completedPositions: 0,
                    color: const Color(0xFF4BC8EB),
                  ),
                ]),
              ),
            ),

            // Bottom space
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyRegionCard(
    BuildContext context, {
    required String title,
    required String emoji,
    required int totalPositions,
    required int completedPositions,
    required Color color,
  }) {
    final progress =
        totalPositions > 0 ? completedPositions / totalPositions : 0.0;

    return InkWell(
      onTap: () {
        // Navigate to region detail screen
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji with colored background
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),

            const Spacer(),

            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: 'Chillax',
              ),
            ),
            const SizedBox(height: 4),

            // Positions count
            Text(
              '$completedPositions of $totalPositions positions',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),

            // Progress bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              borderRadius: BorderRadius.circular(4),
              minHeight: 6,
            ),

            const SizedBox(height: 12),

            // Action button
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        completedPositions > 0 ? 'Continue' : 'Start Learning',
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
