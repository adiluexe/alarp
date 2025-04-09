import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock the orientation to portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALARP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppEntry(),
    );
  }
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _showSplash = true;

  void _completeSplash() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show the splash screen or the main content
    return _showSplash
        ? SplashScreen(onComplete: _completeSplash)
        : const ThemeTestPage(); // Replace with your actual home page
  }
}

// Your existing ThemeTestPage class
class ThemeTestPage extends StatelessWidget {
  const ThemeTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Typography test
            Text('Typography', style: theme.textTheme.headlineMedium),
            const Divider(),

            // Headers (Chillax)
            Text('displayLarge - Chillax', style: theme.textTheme.displayLarge),
            Text(
              'displayMedium - Chillax',
              style: theme.textTheme.displayMedium,
            ),
            // ... rest of your existing ThemeTestPage code
          ],
        ),
      ),
    );
  }
}
