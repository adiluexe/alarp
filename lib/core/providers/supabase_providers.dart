import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:alarp/core/providers/guest_mode_provider.dart';

// Provider for the Supabase client instance
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Provider for the raw Supabase auth state changes stream
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
});

// Provider for the current Supabase User object (null if not logged in)
final currentUserProvider = Provider<User?>((ref) {
  // Listen to the stream and return the current user from the latest AuthState event
  return ref.watch(authStateChangesProvider).value?.session?.user;
});

// Provider for the current user's ID (String?, null if not logged in)
final userIdProvider = Provider<String?>((ref) {
  return ref.watch(currentUserProvider)?.id;
});

// --- NEW: Provider to fetch the current user's profile ---
// We use a StreamProvider to listen for real-time changes to the profile
final userProfileProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  // Return demo profile when in guest mode
  if (ref.watch(guestModeProvider)) {
    return Stream.value(DemoData.userProfile);
  }

  final supabaseClient = ref.watch(supabaseClientProvider);
  final userId = ref.watch(userIdProvider);

  if (userId == null) {
    return Stream.value(null);
  }

  final stream = supabaseClient
      .from('profiles')
      .stream(primaryKey: ['id'])
      .eq('id', userId)
      .limit(1)
      .map((list) => list.isNotEmpty ? list.first : null);

  return stream;
});
