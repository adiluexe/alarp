import 'package:flutter/material.dart';

class RegionCarouselCard extends StatelessWidget {
  final String title;
  final String emoji;
  final int positionCount;
  final Color backgroundColor;
  final VoidCallback? onStartPressed;

  const RegionCarouselCard({
    Key? key,
    required this.title,
    required this.emoji,
    required this.positionCount,
    required this.backgroundColor,
    this.onStartPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      margin: const EdgeInsets.only(right: 16),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  backgroundColor,
                  backgroundColor
                      .withRed((backgroundColor.red + 20).clamp(0, 255))
                      .withGreen((backgroundColor.green + 10).clamp(0, 255)),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '$positionCount positions',
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Chillax',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Practice positioning techniques for ${title.toLowerCase()} radiography',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 16), // Increased from 12 to 16
                SizedBox(
                  height: 36,
                  child: ElevatedButton.icon(
                    onPressed: onStartPressed,
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text('Start Practice'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: backgroundColor,
                      elevation: 0,
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ), // Adjusted padding
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
