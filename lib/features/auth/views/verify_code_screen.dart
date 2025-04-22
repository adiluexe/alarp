import 'dart:async'; // Import async for Timer
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:alarp/core/theme/app_theme.dart';
import 'package:alarp/core/navigation/app_router.dart';
import 'package:alarp/features/auth/controllers/auth_controller.dart';
import 'package:pinput/pinput.dart'; // Import pinput
import 'package:solar_icons/solar_icons.dart'; // Import SolarIcons

class VerifyCodeScreen extends ConsumerStatefulWidget {
  final String email;

  const VerifyCodeScreen({required this.email, super.key});

  @override
  ConsumerState<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends ConsumerState<VerifyCodeScreen> {
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode(); // Optional: for focusing
  bool _isLoading = false;
  bool _isResending = false;
  String? _errorMessage;

  // --- Timer State ---
  Timer? _resendTimer;
  int _resendSecondsRemaining = 60; // Countdown duration
  bool _resendTimerActive = false;
  // --- End Timer State ---

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    _resendTimer?.cancel(); // Cancel timer on dispose
    super.dispose();
  }

  Future<void> _verifyOtp(String otp) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _pinFocusNode.unfocus(); // Unfocus on submit

    try {
      final success = await ref
          .read(authControllerProvider.notifier)
          .verifyOtp(widget.email, otp);

      if (mounted) {
        if (success) {
          // Navigate to the sign up complete screen, replacing the current route
          context.pushReplacement(AppRoutes.signUpComplete);
        } else {
          setState(() {
            _errorMessage = 'Invalid or expired verification code.';
            _pinController.clear(); // Clear input on error
            _pinFocusNode.requestFocus(); // Refocus on error
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An error occurred: ${e.toString()}';
          _pinController.clear();
          _pinFocusNode.requestFocus();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- Timer Logic ---
  void _startResendTimer() {
    _resendTimer?.cancel(); // Cancel any existing timer
    setState(() {
      _resendTimerActive = true;
      _resendSecondsRemaining = 60; // Reset duration
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSecondsRemaining > 0) {
        if (mounted) {
          // Check if widget is still in the tree
          setState(() {
            _resendSecondsRemaining--;
          });
        }
      } else {
        timer.cancel();
        if (mounted) {
          // Check if widget is still in the tree
          setState(() {
            _resendTimerActive = false;
          });
        }
      }
    });
  }
  // --- End Timer Logic ---

  Future<void> _resendOtp() async {
    setState(() {
      _isResending = true;
      _errorMessage = null;
    });
    _pinFocusNode.unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    try {
      final success = await ref
          .read(authControllerProvider.notifier)
          .resendOtp(widget.email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Verification code resent successfully.'
                  : 'Failed to resend code. Please try again later.',
            ),
          ),
        );
        if (success) {
          _pinController.clear();
          _pinFocusNode.requestFocus(); // Focus input after resend
          _startResendTimer(); // Start the timer on successful resend
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Define pinput theme
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: textTheme.headlineSmall?.copyWith(color: AppTheme.textColor),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppTheme.primaryColor, width: 1.5),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: colorScheme.error, width: 1.0),
      ),
    );

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        // Use SolarIcons for back button
        leading: IconButton(
          icon: const Icon(SolarIconsOutline.altArrowLeft),
          onPressed: () => context.pop(),
          color: AppTheme.primaryColor, // Match icon color
        ),
        title: const Text('Verify Email'),
        backgroundColor: colorScheme.background, // Use background color
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppTheme.primaryColor,
          fontFamily: 'Chillax',
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Use SolarIcons Mailbox icon
                Icon(
                  SolarIconsOutline.mailbox,
                  size: 100,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 30),
                Text(
                  'Enter Verification Code',
                  style: textTheme.headlineMedium?.copyWith(
                    fontFamily: 'Chillax',
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onBackground.withOpacity(0.8),
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'We sent a 6-digit code to\n'),
                      TextSpan(
                        text: widget.email,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Use Pinput widget
                Pinput(
                  controller: _pinController,
                  focusNode: _pinFocusNode,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  errorPinTheme: errorPinTheme,
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  // Remove onCompleted to prevent auto-submit
                  // onCompleted: (pin) => _verifyOtp(pin),
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  // Trigger rebuild when text changes to enable/disable button
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 24),
                // Error Message Display
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                    ), // Increased bottom padding
                    child: Text(
                      _errorMessage!,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                // Verify Button
                ElevatedButton(
                  // Disable if loading OR pin is not 6 digits
                  onPressed:
                      _isLoading || _pinController.text.length != 6
                          ? null
                          : () => _verifyOtp(_pinController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    // Style for disabled state
                    disabledBackgroundColor: AppTheme.primaryColor.withOpacity(
                      0.5,
                    ),
                    disabledForegroundColor: Colors.white.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                          : const Text('Verify'),
                ),
                const SizedBox(height: 20),
                // Resend Button / Timer
                _isResending
                    ? const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                    : TextButton(
                      // Disable if loading OR timer is active
                      onPressed:
                          _isLoading || _resendTimerActive ? null : _resendOtp,
                      style: TextButton.styleFrom(
                        foregroundColor:
                            _resendTimerActive
                                ? colorScheme.onBackground.withOpacity(
                                  0.5,
                                ) // Dim color when disabled by timer
                                : AppTheme.primaryColor,
                      ),
                      child: Text(
                        _resendTimerActive
                            ? 'Resend in $_resendSecondsRemaining seconds' // Show timer text
                            : 'Didn\'t receive code? Resend', // Show normal text
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
