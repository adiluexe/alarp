import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes
import 'package:alarp/features/auth/controllers/auth_controller.dart'; // Import authStatusProvider

// Change to ConsumerStatefulWidget
class SplashScreen extends ConsumerStatefulWidget {
  // Remove onComplete as navigation is handled internally now
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

// Change to ConsumerState
class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideUpAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Fade-in animation for logo
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Slide-up animation for text
    _slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutQuint),
      ),
    );

    // Subtle scale animation for logo
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    // Start the animation immediately
    _animationController.forward();

    // Navigate after delay based on auth state
    Timer(const Duration(seconds: 3), () {
      // Check auth state using ref.read (safe in Timer callback)
      final isLoggedIn = ref.read(authStatusProvider);
      if (mounted) {
        // Ensure widget is still in the tree
        if (isLoggedIn) {
          context.go(AppRoutes.home); // Go to home if logged in
        } else {
          context.go(
            AppRoutes.getStarted,
          ); // Go to get started if not logged in
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
            const Spacer(flex: 4),

            // Animated logo
            Center(
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    'assets/images/alarp_logo.png',
                    width: size.width * 0.5,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const Spacer(flex: 3),

            // Animated text section
            SlideTransition(
              position: _slideUpAnimation,
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: Padding(
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
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryColor.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
