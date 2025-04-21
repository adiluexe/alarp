import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provides the Supabase client instance
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Provides the current user's authentication state stream
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return supabaseClient.auth.onAuthStateChange;
});

// Provides the current user ID, or null if not logged in
final userIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  // Use .when to safely access the data, providing null in loading/error states
  return authState.when(
    data: (state) => state.session?.user.id,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Provides the current user object, or null if not logged in
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  // Use .when to safely access the data, providing null in loading/error states
  return authState.when(
    data: (state) => state.session?.user,
    loading: () => null,
    error: (_, __) => null,
  );
});
