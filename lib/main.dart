import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/core/navigation/app_router.dart'; // Import the router provider
import 'package:alarp/core/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import flutter_dotenv

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase using environment variables
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

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
