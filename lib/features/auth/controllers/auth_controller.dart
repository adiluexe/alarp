import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:alarp/core/providers/supabase_providers.dart';

// Provider for the AuthController
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
      return AuthController(ref);
    });

// Provider to expose the raw Supabase auth state stream
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return supabaseClient.auth.onAuthStateChange;
});

// Simple boolean provider for logged-in status
final authStatusProvider = Provider<bool>((ref) {
  // Watch the stream provider
  final authState = ref.watch(authStateChangesProvider);
  // Return true if there's a user session, false otherwise
  return authState.when(
    data: (state) => state.session?.user != null,
    loading: () => false, // Assume not logged in while loading
    error: (_, __) => false, // Assume not logged in on error
  );
});

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;
  StreamSubscription<AuthState>? _authStateSubscription;

  AuthController(this._ref) : super(const AsyncLoading()) {
    _initialize();
  }

  void _initialize() {
    final supabaseClient = _ref.read(supabaseClientProvider);
    // Set initial state
    state = AsyncValue.data(supabaseClient.auth.currentUser);

    // Listen to auth state changes
    _authStateSubscription = supabaseClient.auth.onAuthStateChange.listen(
      (data) {
        state = AsyncValue.data(data.session?.user);
      },
      onError: (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );
  }

  Future<bool> signUp(
    String email,
    String password, {
    String? firstName,
    String? lastName,
  }) async {
    state = const AsyncLoading();
    try {
      final supabaseClient = _ref.read(supabaseClientProvider);
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          if (firstName != null && firstName.isNotEmpty)
            'first_name': firstName,
          if (lastName != null && lastName.isNotEmpty) 'last_name': lastName,
        },
      );
      // IMPORTANT: Return true immediately after successful Supabase call
      // for OTP flow, as the user isn't logged in yet.
      print('Supabase signUp call successful, returning true.'); // Add logging
      return true;
    } on AuthException catch (e, stackTrace) {
      print('AuthException during signup: ${e.message}');
      state = AsyncValue.error(e, stackTrace);
      return false;
    } catch (e, stackTrace) {
      print('Generic error during signup: $e');
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      final supabaseClient = _ref.read(supabaseClientProvider);
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      // State will be updated by the authStateChangesProvider listener
      // state = AsyncValue.data(response.user);
      return true;
    } on AuthException catch (e, stackTrace) {
      print('AuthException during signin: ${e.message}');
      state = AsyncValue.error(e, stackTrace);
      return false;
    } catch (e, stackTrace) {
      print('Generic error during signin: $e');
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  // --- New Method for OTP Verification ---
  Future<bool> verifyOtp(String email, String otp) async {
    state = const AsyncLoading(); // Indicate loading state
    try {
      final supabaseClient = _ref.read(supabaseClientProvider);
      final response = await supabaseClient.auth.verifyOTP(
        type: OtpType.signup, // Specify the type of OTP
        token: otp,
        email: email,
      );
      // If verifyOTP is successful, the user is confirmed and logged in.
      // The authStateChangesProvider listener will automatically update the state.
      // state = AsyncValue.data(response.user);
      return true; // Indicate verification success
    } on AuthException catch (e, stackTrace) {
      print('AuthException during OTP verification: ${e.message}');
      state = AsyncValue.error(e, stackTrace);
      // Restore previous state or keep error state?
      // For simplicity, keep error state, but you might want to revert.
      // state = AsyncValue.data(supabaseClient.auth.currentUser); // Revert example
      return false; // Indicate verification failure
    } catch (e, stackTrace) {
      print('Generic error during OTP verification: $e');
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }
  // --- End New Method ---

  // --- New Method for Resending OTP ---
  Future<bool> resendOtp(String email) async {
    // No need to change the main state notifier state for resend
    try {
      final supabaseClient = _ref.read(supabaseClientProvider);
      // Use the resend method for signup OTP
      await supabaseClient.auth.resend(type: OtpType.signup, email: email);
      return true; // Indicate resend request was successful
    } on AuthException catch (e, stackTrace) {
      print('AuthException during OTP resend: ${e.message}');
      // Optionally update state to reflect error, but usually handled by UI
      // state = AsyncValue.error(e, stackTrace);
      return false; // Indicate resend failure
    } catch (e, stackTrace) {
      print('Generic error during OTP resend: $e');
      // state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }
  // --- End New Method ---

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      final supabaseClient = _ref.read(supabaseClientProvider);
      await supabaseClient.auth.signOut();
      // State will be updated by the authStateChangesProvider listener
      // state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
