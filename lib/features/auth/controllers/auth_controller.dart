import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:alarp/core/providers/supabase_providers.dart'; // Import supabase provider

// Simple state enum for loading states
enum AuthStateEnum { initial, loading, success, error }

class AuthController extends StateNotifier<AuthStateEnum> {
  final Ref _ref;

  AuthController(this._ref) : super(AuthStateEnum.initial);

  SupabaseClient get _supabaseClient => _ref.read(supabaseClientProvider);

  // Getter to easily check if the user is currently authenticated
  bool get isAuthenticated => _ref.read(currentUserProvider) != null;

  // Updated signUp method to accept optional firstName and lastName
  Future<bool> signUp(
    String email,
    String password, {
    String? firstName, // Add firstName
    String? lastName, // Add lastName
  }) async {
    state = AuthStateEnum.loading;
    try {
      // Prepare metadata, including username derived from names if needed later
      // For now, just pass first and last name if provided.
      // Supabase uses 'data' for user_metadata.
      final Map<String, dynamic> userMetadata = {};
      if (firstName != null && firstName.isNotEmpty) {
        userMetadata['first_name'] = firstName;
      }
      if (lastName != null && lastName.isNotEmpty) {
        userMetadata['last_name'] = lastName;
      }
      // You could also create a 'full_name' or default 'username' here
      // if (firstName != null && lastName != null) {
      //   userMetadata['full_name'] = '$firstName $lastName';
      // }

      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: userMetadata.isNotEmpty ? userMetadata : null, // Pass metadata
      );
      // Check if sign up requires email confirmation (check your Supabase project settings)
      final session = response.session;
      final user = response.user;

      if (user != null) {
        if (session == null && user.aud == 'authenticated') {
          // User exists but no session - likely needs email confirmation
          print(
            "Sign up successful, please check your email for confirmation.",
          );
          state =
              AuthStateEnum
                  .success; // Or a specific state like 'needsConfirmation'
          // Don't automatically consider them 'authenticated' yet
          return true; // Indicate sign up process initiated
        } else if (session != null) {
          // User signed up and is immediately logged in (email confirmation might be off)
          print("Sign up successful and logged in.");
          state = AuthStateEnum.success;
          return true;
        }
      }
      // Handle other potential scenarios or errors if needed
      print(
        "Sign up response indicates an issue: User=${user?.id}, Session=${session != null}",
      );
      state = AuthStateEnum.error;
      return false;
    } on AuthException catch (e) {
      print('AuthException during sign up: ${e.message}'); // Log or show error
      state = AuthStateEnum.error;
      return false;
    } catch (e) {
      print('Unexpected error during sign up: $e'); // Log or show error
      state = AuthStateEnum.error;
      return false;
    } finally {
      // Avoid staying in loading state indefinitely if sign up doesn't throw but isn't fully successful
      if (state == AuthStateEnum.loading) {
        state =
            AuthStateEnum.initial; // Or error, depending on desired behavior
      }
    }
  }

  Future<bool> signIn(String email, String password) async {
    state = AuthStateEnum.loading;
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        print("Sign in successful.");
        state = AuthStateEnum.success;
        return true;
      } else {
        print("Sign in failed: No user returned.");
        state = AuthStateEnum.error; // Should not happen on success
        return false;
      }
    } on AuthException catch (e) {
      print('AuthException during sign in: ${e.message}'); // Log or show error
      state = AuthStateEnum.error;
      return false;
    } catch (e) {
      print('Unexpected error during sign in: $e'); // Log or show error
      state = AuthStateEnum.error;
      return false;
    } finally {
      if (state == AuthStateEnum.loading) {
        state = AuthStateEnum.initial;
      }
    }
  }

  Future<void> signOut() async {
    // No need for loading state here unless signout is slow/complex
    // state = AuthStateEnum.loading;
    try {
      await _supabaseClient.auth.signOut();
      print("Sign out successful.");
      state = AuthStateEnum.initial; // Reset state after sign out
    } on AuthException catch (e) {
      print('AuthException during sign out: ${e.message}'); // Log or show error
      // Decide if state should be error or just remain initial
      state = AuthStateEnum.error;
    } catch (e) {
      print('Unexpected error during sign out: $e'); // Log or show error
      state = AuthStateEnum.error;
    }
  }
}

// Provider for the AuthController
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthStateEnum>((ref) {
      return AuthController(ref);
    });

// Provider to easily check authentication status reactively
final authStatusProvider = Provider<bool>((ref) {
  // Watch the auth state changes
  final authState = ref.watch(authStateChangesProvider);
  // Return true if there's a valid session and user
  return authState.maybeWhen(
    data: (state) => state.session?.user != null,
    orElse: () => false, // Default to false in loading/error states
  );
});
