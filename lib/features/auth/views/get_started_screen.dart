import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              // Top Section (ALARP Title)
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

              // Middle Section (Hero Image Only) - Emphasized
              // Remove Padding wrapper, let spaceBetween handle vertical distribution
              Image.asset(
                'assets/images/alarp_hero.webp',
                // Significantly increase height, adjust width accordingly
                height: screenHeight * 0.45, // Increased height
                width: screenWidth, // Span full width
                fit: BoxFit.cover, // Contain ensures aspect ratio is maintained
              ),

              // Bottom Section (Welcome Text & Buttons)
              Padding(
                padding: EdgeInsets.only(
                  bottom: screenHeight * 0.04,
                ), // Adjust bottom padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Welcome Text (Moved Here)
                    Text(
                      'Welcome to ALARP',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontFamily: 'Chillax',
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4), // Reduced spacing slightly
                    Text(
                      'A Learning Aid in Radiographic Positioning',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryColor.withOpacity(0.8),
                        fontFamily: 'Satoshi',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16), // Spacing before buttons
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
                        onPressed: () {
                          context.push(AppRoutes.signUp);
                        },
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
                    const SizedBox(height: 12), // Adjusted spacing
                    // Log In Link
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
