import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/core/navigation/app_router.dart';
import 'package:solar_icons/solar_icons.dart'; // Optional: For button icon

class SignUpCompleteScreen extends StatelessWidget {
  const SignUpCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Allows scrolling on smaller screens
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 48.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero Image
                Image.asset(
                  'assets/images/alarp_hero.webp',
                  height: 250, // Adjust height as needed
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),

                // Success Message
                Text(
                  'Registration Successful!',
                  style: textTheme.headlineMedium?.copyWith(
                    fontFamily: 'Chillax',
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Welcome Note
                Text(
                  'Welcome to ALARP! You\'re all set to start mastering radiographic positioning.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.8),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Action Button
                ElevatedButton.icon(
                  icon: const Icon(SolarIconsOutline.home), // Optional icon
                  label: const Text('Let\'s Get Started'),
                  onPressed: () {
                    // Use context.go to reset the navigation stack to home
                    context.go(AppRoutes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
