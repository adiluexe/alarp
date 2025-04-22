import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/core/navigation/app_router.dart'; // Import AppRoutes

class CheckEmailScreen extends StatelessWidget {
  final String? email;

  // Apply use_super_parameters fix
  const CheckEmailScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Check Your Email'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.primaryColor),
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: AppTheme.primaryColor,
          fontFamily: 'Chillax',
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.mark_email_read_outlined,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 30),
              Text(
                'Verify Your Email Address',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontFamily: 'Chillax',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                email != null
                    // Fix string interpolation/concatenation
                    ? 'We sent a confirmation link to:\n$email'
                    : 'We sent a confirmation link to your email address.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textColor,
                  fontFamily: 'Satoshi',
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Please click the link in the email to activate your account. You might need to check your spam folder.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  // Replace deprecated withOpacity
                  color: AppTheme.textColor.withAlpha((255 * 0.7).round()),
                  fontFamily: 'Satoshi',
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Optional: Add a "Resend Email" button here if needed
              // Optional: Add a button to go back to login
              TextButton(
                onPressed: () {
                  // Navigate back to the sign-in screen
                  context.go(AppRoutes.signIn);
                },
                child: Text(
                  'Back to Log In',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.primaryColor,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
