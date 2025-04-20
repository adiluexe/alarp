import 'package:alarp/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

class LeaderboardEntry {
  final int rank;
  final String name;
  final int score;
  final String? avatarUrl;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.score,
    this.avatarUrl,
    this.isCurrentUser = false,
  });
}

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  // Updated mock data with "FirstName, Initial." format
  final List<LeaderboardEntry> mockLeaderboardData = const [
    LeaderboardEntry(rank: 1, name: 'Sebastian, B.', score: 5000),
    LeaderboardEntry(rank: 2, name: 'Michael, B.', score: 4850),
    LeaderboardEntry(
      rank: 3,
      name: 'You', // Keep 'You' for the current user
      score: 4700,
      isCurrentUser: true,
    ),
    LeaderboardEntry(rank: 4, name: 'David, L.', score: 4450),
    LeaderboardEntry(rank: 5, name: 'Emily, C.', score: 4350),
    LeaderboardEntry(rank: 6, name: 'James, R.', score: 4100),
    LeaderboardEntry(rank: 7, name: 'Olivia, M.', score: 3800),
    LeaderboardEntry(rank: 8, name: 'Daniel, P.', score: 3500),
    LeaderboardEntry(rank: 9, name: 'Sophia, T.', score: 3200),
    LeaderboardEntry(rank: 10, name: 'Chris, J.', score: 3000),
  ];

  @override
  Widget build(BuildContext context) {
    final topThree = mockLeaderboardData.where((e) => e.rank <= 3).toList();
    final rank1 = topThree.firstWhere(
      (e) => e.rank == 1,
      orElse: () => const LeaderboardEntry(rank: 1, name: '-', score: 0),
    );
    final rank2 = topThree.firstWhere(
      (e) => e.rank == 2,
      orElse: () => const LeaderboardEntry(rank: 2, name: '-', score: 0),
    );
    final rank3 = topThree.firstWhere(
      (e) => e.rank == 3,
      orElse: () => const LeaderboardEntry(rank: 3, name: '-', score: 0),
    );
    final remainingEntries =
        mockLeaderboardData.where((e) => e.rank > 3).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Leaderboard'),
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          onPressed: () => context.pop(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.secondaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.backgroundColor,
              AppTheme.backgroundColor.withBlue(245).withGreen(245),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Sticky header with shadow and rounded corners
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            SolarIconsOutline.ranking,
                            color: AppTheme.primaryColor,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Top Performers",
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                              fontFamily: 'Chillax',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildPodium(context, rank1, rank2, rank3),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Icon(
                        SolarIconsOutline.usersGroupRounded,
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'All Rankings',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  itemCount: remainingEntries.length,
                  itemBuilder: (context, index) {
                    final entry = remainingEntries[index];
                    return _buildLeaderboardListTile(context, entry);
                  },
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 8),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPodium(
    BuildContext context,
    LeaderboardEntry rank1,
    LeaderboardEntry rank2,
    LeaderboardEntry rank3,
  ) {
    const goldColor = Color(0xFFFAD961);
    const silverColor = Color(0xFFE2E2E2);
    const bronzeColor = Color(0xFFD1A683);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildPodiumItem(context, rank2, silverColor, 90)),
          Expanded(child: _buildPodiumItem(context, rank1, goldColor, 120)),
          Expanded(child: _buildPodiumItem(context, rank3, bronzeColor, 80)),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(
    BuildContext context,
    LeaderboardEntry entry,
    Color color,
    double height,
  ) {
    // Determine the initial to display (handle "You")
    String initial = '?';
    if (entry.name.isNotEmpty) {
      if (entry.isCurrentUser && entry.name == 'You') {
        initial = 'Y'; // Special case for "You"
      } else if (entry.name.contains(',')) {
        initial =
            entry.name
                .split(',')[0][0]
                .toUpperCase(); // First letter of first name
      } else {
        initial =
            entry.name[0].toUpperCase(); // Fallback for names without comma
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color.withOpacity(0.6),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Text(
              initial, // Use the determined initial
              style: TextStyle(
                fontSize: 20,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'Chillax',
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          entry.name, // Display the full name
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textColor.withOpacity(0.9),
            fontFamily: 'Satoshi',
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${entry.score} pts',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textColor.withOpacity(0.7),
            fontWeight: FontWeight.w500,
            fontFamily: 'Satoshi',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  SolarIconsBold.medalStar,
                  color: Colors.white.withOpacity(0.85),
                  size: Theme.of(context).textTheme.headlineSmall?.fontSize,
                ),
                const SizedBox(width: 4),
                Text(
                  '#${entry.rank}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Chillax',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardListTile(
    BuildContext context,
    LeaderboardEntry entry,
  ) {
    final currentUserGradient = LinearGradient(
      colors: [
        AppTheme.primaryColor.withOpacity(0.15),
        AppTheme.secondaryColor.withOpacity(0.1),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    final regularCardGradient = LinearGradient(
      colors: [
        Colors.white,
        Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // Determine the initial to display (handle "You")
    String initial = '?';
    if (entry.name.isNotEmpty) {
      if (entry.isCurrentUser && entry.name == 'You') {
        initial = 'Y'; // Special case for "You"
      } else if (entry.name.contains(',')) {
        initial =
            entry.name
                .split(',')[0][0]
                .toUpperCase(); // First letter of first name
      } else {
        initial =
            entry.name[0].toUpperCase(); // Fallback for names without comma
      }
    }

    return Card(
      elevation: entry.isCurrentUser ? 2.0 : 1.0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side:
            entry.isCurrentUser
                ? BorderSide(
                  color: AppTheme.primaryColor.withOpacity(0.5),
                  width: 1,
                )
                : BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient:
              entry.isCurrentUser ? currentUserGradient : regularCardGradient,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Row(
          children: [
            SizedBox(
              width: 76,
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Text(
                      '#${entry.rank}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.6),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Chillax',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.18),
                    child: Text(
                      initial, // Use the determined initial
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Chillax',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                entry.name, // Display the full name
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight:
                      entry.isCurrentUser ? FontWeight.w700 : FontWeight.w600,
                  color: AppTheme.textColor.withOpacity(0.9),
                  fontFamily: 'Satoshi',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${entry.score} pts',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  fontFamily: 'Satoshi',
                ),
                maxLines: 1,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
