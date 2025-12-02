import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/practice/models/body_region.dart';
import 'package:alarp/core/navigation/app_router.dart';

class RegionMasterScreen extends ConsumerWidget {
  const RegionMasterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Region Master'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            SolarIconsOutline.altArrowLeft,
            color: AppTheme.textColor,
          ),
          onPressed: () => context.pop(),
        ),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontFamily: 'Chillax',
          fontWeight: FontWeight.bold,
          color: AppTheme.textColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Region',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Master specific body areas with focused speed runs.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: BodyRegions.allRegions.length,
                itemBuilder: (context, index) {
                  final region = BodyRegions.allRegions[index];
                  return _buildRegionCard(context, region);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionCard(BuildContext context, BodyRegion region) {
    return InkWell(
      onTap: () {
        context.push(
          AppRoutes.regionMasterGameRoute(region.title),
        ); // Use title as ID for now as it matches lesson.bodyRegion usually, but better to check data consistency.
        // Actually lesson.bodyRegion uses strings like 'Upper Extremity'.
        // BodyRegion.title is 'Upper Extremity'. So it matches.
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: region.backgroundColor.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: region.backgroundColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(region.emoji, style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(height: 16),
            Text(
              region.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${region.positionCount} Positions',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textColor.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
