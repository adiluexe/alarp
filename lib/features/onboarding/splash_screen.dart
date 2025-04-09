import 'dart:async';
import 'package:flutter/material.dart';
import 'package:alarp/core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the main screen after 3 seconds
    Timer(const Duration(seconds: 3), widget.onComplete);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // This spacer pushes the logo down from the top
            const Spacer(flex: 4),

            // Logo centered in the middle ~80% of screen
            Center(
              child: Image.asset(
                'assets/images/alarp_logo.png',
                width: size.width * 0.5, // 60% of screen width
                fit: BoxFit.cover,
              ),
            ),

            // This large spacer pushes the text to the bottom
            const Spacer(flex: 3),

            // Bottom text section with padding
            Padding(
              padding: const EdgeInsets.only(
                bottom: 48.0,
                left: 24.0,
                right: 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ALARP',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontFamily: 'Chillax',
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'A Learning Aid In Radiographic Positioning',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textColor.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
