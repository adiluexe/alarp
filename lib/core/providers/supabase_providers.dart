import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final supabaseClient = ref.watch(supabaseClientProvider);
  final userId = ref.watch(userIdProvider);

  // If no user is logged in, return an empty stream
  if (userId == null) {
    return Stream.value(null);
  }

  // Fetch the user's profile row from the 'profiles' table
  // Call .stream() immediately after .from()
  // Then apply filters and transformations to the stream
  final stream = supabaseClient
      .from('profiles')
      .stream(primaryKey: ['id']) // Call stream() directly on the table query
      .eq('id', userId) // Filter the stream
      .limit(1) // Limit the stream results
      // The stream returns a List<Map<String, dynamic>>, map it to a single Map or null
      .map((list) => list.isNotEmpty ? list.first : null);

  // Note: .select() is implicitly applied when fetching the stream unless specified otherwise.
  // If you only need specific columns, you could add .select('username, first_name, ...')
  // *before* .stream(), but fetching all columns is often fine for a single profile row.

  return stream;
});
