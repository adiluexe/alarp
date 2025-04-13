import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/core/navigation/app_router.dart'; // Import the router provider
import 'package:alarp/core/theme/app_theme.dart';
// Import other necessary initializers like Supabase

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Supabase or other services here if needed
  // await Supabase.initialize(...);

  runApp(
    // Wrap the entire app in a ProviderScope for Riverpod
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the router provider
    final goRouter = ref.watch(goRouterProvider);

    // Use MaterialApp.router
    return MaterialApp.router(
      title: 'ALARP',
      theme: AppTheme.lightTheme, // Use your app theme
      // Router configuration
      routerConfig: goRouter, // Pass the GoRouter instance here
      debugShowCheckedModeBanner: false,
    );
  }
}
