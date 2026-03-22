import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/core/navigation/app_router.dart';
import 'package:alarp/core/providers/guest_mode_provider.dart';

class GetStartedScreen extends ConsumerWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.05),
                child: Text(
                  'ALARP',
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: AppTheme.primaryColor,
                    fontFamily: 'Chillax',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              Image.asset(
                'assets/images/alarp_hero.webp',
                height: screenHeight * 0.45,
                width: screenWidth,
                fit: BoxFit.cover,
              ),

              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.04),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome to ALARP',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontFamily: 'Chillax',
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'A Learning Aid in Radiographic Positioning',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryColor.withValues(alpha: 0.8),
                        fontFamily: 'Satoshi',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Get Started Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () => context.push(AppRoutes.signUp),
                        child: Text(
                          'Get Started',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Satoshi',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Continue as Guest Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: const BorderSide(
                            color: AppTheme.primaryColor,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          ref.read(guestModeProvider.notifier).state = true;
                          context.go(AppRoutes.home);
                        },
                        child: Text(
                          'Continue as Guest',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Satoshi',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontFamily: 'Satoshi',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.signIn),
                          child: Text(
                            'Log In',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: AppTheme.primaryColor,
                              fontFamily: 'Satoshi',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
