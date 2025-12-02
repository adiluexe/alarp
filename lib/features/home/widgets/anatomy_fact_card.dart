import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'dart:math';

class AnatomyFactCard extends StatelessWidget {
  const AnatomyFactCard({super.key});

  static const List<String> _facts = [
    'The human hand has 27 bones, not including the sesamoid bone.',
    'The femur is the longest and strongest bone in the human body.',
    'The smallest bone in the body is the stapes, located in the middle ear.',
    'Babies are born with about 300 bones, but adults have only 206.',
    'The hyoid bone is the only bone in the human body not connected to another bone.',
    'Your bones are composed of 50% water and 50% solid matter.',
    'The hands and feet contain more than half of the bones in your body.',
  ];

  @override
  Widget build(BuildContext context) {
    // Pick a random fact based on the day of the year to keep it consistent for the day
    // or just random for now. Let's do random for variety on refresh.
    final random = Random();
    final fact = _facts[random.nextInt(_facts.length)];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                SolarIconsBold.lightbulb,
                color: AppTheme.accentColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Did You Know?',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            fact,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
