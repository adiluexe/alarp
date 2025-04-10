import 'package:flutter/material.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/features/practice/models/body_region.dart';
import 'package:alarp/features/practice/models/body_part.dart';
import 'package:alarp/features/practice/widgets/body_part_card.dart';
import 'package:alarp/features/practice/views/positioning_practice_screen.dart';

class RegionDetailScreen extends StatelessWidget {
  final BodyRegion region;

  const RegionDetailScreen({Key? key, required this.region}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(region.title),
        backgroundColor: region.backgroundColor,
        foregroundColor: Colors.white,
      ),
      body: CustomScrollView(
        slivers: [
          // Region header
          SliverToBoxAdapter(child: _buildRegionHeader(context)),

          // Body parts list
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final bodyPart = region.bodyParts[index];
                return BodyPartCard(
                  bodyPart: bodyPart,
                  onTap: () {
                    // Navigate to positioning practice screen
                    _navigateToPositioningPractice(context, bodyPart);
                  },
                );
              }, childCount: region.bodyParts.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: region.backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Region info
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    region.emoji,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Practice ${region.title}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Chillax',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${region.positionCount} positioning techniques',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Practice instructions
          Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: region.backgroundColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    SolarIconsOutline.lightbulb,
                    color: region.backgroundColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Select a specific body part below to practice positioning techniques',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPositioningPractice(BuildContext context, BodyPart bodyPart) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => PositioningPracticeScreen(
              bodyPart: bodyPart.title,
              projectionName:
                  bodyPart
                      .projections
                      .first, // For example, taking the first projection
            ),
      ),
    );
  }
}
