import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/core/navigation/app_router.dart'; // Import the router provider
import 'package:alarp/core/theme/app_theme.dart'; // Import your theme

void main() {
  runApp(
    const ProviderScope(
      // Ensure ProviderScope is at the root
      child: MyApp(),
    ),
  );
}

// Make MyApp a ConsumerWidget to access the router provider
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the GoRouter instance from the provider
    final router = ref.watch(goRouterProvider);

    // Use MaterialApp.router
    return MaterialApp.router(
      title: 'ALARP',
      theme: AppTheme.lightTheme, // Apply your theme
      debugShowCheckedModeBanner: false,
      // Configure the router
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
