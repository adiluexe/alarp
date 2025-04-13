import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../models/challenge_step.dart';

class PositioningSelectionWidget extends StatefulWidget {
  final PositioningSelectionStep step;
  final Function(int) onSelected;
  final int? selectedIndex; // Make nullable

  const PositioningSelectionWidget({
    super.key,
    required this.step,
    required this.onSelected,
    this.selectedIndex, // Updated
  });

  @override
  State<PositioningSelectionWidget> createState() =>
      _PositioningSelectionWidgetState();
}

class _PositioningSelectionWidgetState
    extends State<PositioningSelectionWidget> {
  late final PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      final newIndex = _pageController.page?.round() ?? 0;
      if (newIndex != _currentPageIndex) {
        setState(() {
          _currentPageIndex = newIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              widget.step.instruction,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          // Constrain the PageView instead of using Center(Expanded(...))
          SizedBox(
            // Adjust height as needed, e.g., based on screen size or fixed value
            height: MediaQuery.of(context).size.height * 0.4,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.step.imageOptions.length,
              itemBuilder: (context, index) {
                String imagePath = widget.step.imageOptions[index];
                bool isSelected = widget.selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border:
                          isSelected
                              ? Border.all(
                                color: AppTheme.primaryColor,
                                width: 3,
                              ) // Highlight if selected
                              : null,
                      boxShadow: [
                        BoxShadow(
                          // Fix deprecated withOpacity
                          color: Colors.black.withAlpha((255 * 0.1).round()),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SmoothPageIndicator(
            controller: _pageController,
            count: widget.step.imageOptions.length,
            effect: WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: AppTheme.primaryColor,
              dotColor: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(SolarIconsBold.checkCircle),
                label: const Text('Select This Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => widget.onSelected(_currentPageIndex),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
