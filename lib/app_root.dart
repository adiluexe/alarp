import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/features/onboarding/splash_screen.dart';
import 'package:alarp/main.dart'; // Import MyApp
import 'package:alarp/core/providers/app_providers.dart'; // Import the splash provider
import 'package:alarp/core/theme/app_theme.dart'; // Import theme for splash MaterialApp

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSplashFinished = ref.watch(isSplashFinishedProvider);

    if (!isSplashFinished) {
      // Show splash screen until it completes
      // Wrap SplashScreen in a MaterialApp to provide Directionality etc.
      return MaterialApp(
        home: SplashScreen(
          onComplete: () {
            // Update the provider state when splash is done
            ref.read(isSplashFinishedProvider.notifier).state = true;
          },
        ),
        theme: AppTheme.lightTheme, // Apply theme for consistency if needed
        debugShowCheckedModeBanner: false,
      );
    } else {
      // Splash is finished, show the main app with the router
      return const MyApp();
    }
  }
}
