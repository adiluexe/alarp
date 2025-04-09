import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

class TestTheme extends StatelessWidget {
  const TestTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALARP',
      theme: AppTheme.lightTheme,
      home: const ThemeTestPage(),
    );
  }
}

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
            Text('displaySmall - Chillax', style: theme.textTheme.displaySmall),
            Text(
              'headlineLarge - Chillax',
              style: theme.textTheme.headlineLarge,
            ),
            Text(
              'headlineMedium - Chillax',
              style: theme.textTheme.headlineMedium,
            ),
            Text(
              'headlineSmall - Chillax',
              style: theme.textTheme.headlineSmall,
            ),
            Text('titleLarge - Chillax', style: theme.textTheme.titleLarge),

            const SizedBox(height: 20),

            // Body (Satoshi)
            Text('titleMedium - Satoshi', style: theme.textTheme.titleMedium),
            Text('titleSmall - Satoshi', style: theme.textTheme.titleSmall),
            Text('bodyLarge - Satoshi', style: theme.textTheme.bodyLarge),
            Text('bodyMedium - Satoshi', style: theme.textTheme.bodyMedium),
            Text('bodySmall - Satoshi', style: theme.textTheme.bodySmall),

            const SizedBox(height: 20),

            // Weight tests
            Text(
              'Chillax Font Weight Test',
              style: theme.textTheme.headlineSmall,
            ),
            const Divider(),
            Text(
              'Weight 400 (Regular)',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Weight 500 (Medium)',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Weight 600 (Semibold)',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Weight 700 (Bold)',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Satoshi Font Weight Test',
              style: theme.textTheme.headlineSmall,
            ),
            const Divider(),
            Text(
              'Weight 300 (Light)',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Weight 400 (Regular)',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Weight 500 (Medium)',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Weight 700 (Bold)',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Weight 900 (Black)',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 30),

            // Color test
            Text('Color Scheme', style: theme.textTheme.headlineMedium),
            const Divider(),
            _ColorBox(color: colorScheme.primary, name: 'Primary'),
            _ColorBox(color: colorScheme.secondary, name: 'Secondary'),
            _ColorBox(color: colorScheme.tertiary, name: 'Tertiary/Accent'),
            _ColorBox(color: colorScheme.error, name: 'Error'),
            _ColorBox(color: colorScheme.surface, name: 'Surface'),
            _ColorBox(color: colorScheme.background, name: 'Background'),
          ],
        ),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  final Color color;
  final String name;

  const _ColorBox({required this.color, required this.name});

  @override
  Widget build(BuildContext context) {
    final textColor =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          name,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
