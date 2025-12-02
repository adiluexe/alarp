import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:solar_icons/solar_icons.dart'; // Import Solar Icons
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/features/practice/models/body_region.dart'; // Assuming models are shared or moved to core
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<BodyRegion> _filteredRegions = [];
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Upper Body',
    'Lower Body',
    'Spine',
    'Thorax',
  ];

  @override
  void initState() {
    super.initState();
    _filteredRegions = BodyRegions.allRegions;
    _searchController.addListener(_filterRegions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRegions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      var regions = BodyRegions.allRegions;

      // Filter by Category
      if (_selectedCategory != 'All') {
        regions =
            regions.where((region) {
              switch (_selectedCategory) {
                case 'Upper Body':
                  return [
                    'upper_extremity',
                    'head_&_neck',
                    'thorax',
                  ].contains(region.id);
                case 'Lower Body':
                  return [
                    'lower_extremity',
                    'abdomen_&_pelvis',
                  ].contains(region.id);
                case 'Spine':
                  return region.id == 'spine';
                case 'Thorax':
                  return region.id == 'thorax';
                default:
                  return true;
              }
            }).toList();
      }

      // Filter by Search Query
      if (query.isNotEmpty) {
        regions =
            regions.where((region) {
              final titleMatch = region.title.toLowerCase().contains(query);
              final partMatch = region.bodyParts.any(
                (part) =>
                    part.title.toLowerCase().contains(query) ||
                    part.projections.any(
                      (proj) => proj.toLowerCase().contains(query),
                    ),
              );
              return titleMatch || partMatch;
            }).toList();
      }

      _filteredRegions = regions;
    });
  }

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
                        color: AppTheme.textColor.withAlpha(
                          (255 * 0.7).round(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Search Bar
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search regions, parts, or projections...',
                        prefixIcon: const Icon(SolarIconsOutline.magnifier),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Category Filters
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final category in _categories)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                label: Text(category),
                                selected: _selectedCategory == category,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory = category;
                                    _filterRegions();
                                  });
                                },
                                backgroundColor: Colors.white,
                                selectedColor: AppTheme.primaryColor
                                    .withOpacity(0.2),
                                labelStyle: TextStyle(
                                  color:
                                      _selectedCategory == category
                                          ? AppTheme.primaryColor
                                          : AppTheme.textColor,
                                  fontWeight:
                                      _selectedCategory == category
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color:
                                        _selectedCategory == category
                                            ? AppTheme.primaryColor
                                            : Colors.transparent,
                                  ),
                                ),
                                showCheckmark: false,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Body regions grid
            if (_filteredRegions.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          SolarIconsOutline.magnifier,
                          size: 48,
                          color: AppTheme.textColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No matching regions found',
                          style: TextStyle(
                            color: AppTheme.textColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final region = _filteredRegions[index];
                    return _buildBodyRegionCard(
                      context,
                      region: region,
                      completedPositions: 0,
                    );
                  }, childCount: _filteredRegions.length),
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
    required BodyRegion region,
    required int completedPositions,
  }) {
    final progress =
        region.positionCount > 0
            ? completedPositions / region.positionCount
            : 0.0;
    const Color contentColor = Colors.white;

    return InkWell(
      onTap: () {
        context.go(
          '${AppRoutes.learn}/${AppRoutes.learnRegionDetail.replaceFirst(':regionId', region.id)}',
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: region.backgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: region.backgroundColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji Icon
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(region.emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const Spacer(),
            // Title
            Text(
              region.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontFamily: 'Chillax',
                color: contentColor,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Progress Text
            Text(
              '${region.positionCount} Topics',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: contentColor.withOpacity(0.8),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            // Progress Bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              borderRadius: BorderRadius.circular(4),
              minHeight: 4,
            ),
          ],
        ),
      ),
    );
  }
}
