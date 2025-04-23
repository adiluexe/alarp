import 'package:alarp/core/error/exceptions.dart';
import 'package:alarp/features/practice/models/practice_attempt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    hide AuthException; // Hide Supabase AuthException
import 'dart:developer' as developer; // Use developer log

// Interface for the Practice Data Source
abstract class PracticeDataSource {
  Future<void> addPracticeAttempt({
    required String bodyPartId,
    required String projectionName,
    required double accuracy,
  });

  Future<List<PracticeAttempt>> getRecentPracticeAttempts({int limit = 5});

  Future<List<PracticeAttempt>> getAllPracticeAttempts();

  Future<double> getWeeklyAverageAccuracy();

  Future<double> getOverallAverageAccuracy();
}

// Implementation using Supabase
class SupabasePracticeDataSource implements PracticeDataSource {
  final SupabaseClient _client;

  SupabasePracticeDataSource(this._client);

  String _getUserId() {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw AuthException('User not authenticated.'); // Added throw
    }
    return user.id;
  }

  @override
  Future<void> addPracticeAttempt({
    required String bodyPartId,
    required String projectionName,
    required double accuracy,
  }) async {
    final userId = _getUserId();
    try {
      await _client.from('practice_attempts').insert({
        'user_id': userId,
        'body_part_id': bodyPartId,
        'projection_name': projectionName,
        'accuracy': accuracy,
      });
      developer.log(
        'Practice attempt added successfully',
        name: 'SupabasePracticeDataSource',
      );
    } on PostgrestException catch (e) {
      developer.log(
        'Error adding practice attempt: ${e.message}',
        error: e,
        name: 'SupabasePracticeDataSource',
      );
      throw ServerException(
        'Failed to add practice attempt: ${e.message}',
        e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      developer.log(
        'Unexpected error adding practice attempt: $e',
        error: e,
        name: 'SupabasePracticeDataSource',
      );
      throw ServerException(
        'An unexpected error occurred while adding the practice attempt.',
      );
    }
  }

  @override
  Future<List<PracticeAttempt>> getRecentPracticeAttempts({
    int limit = 5,
  }) async {
    final userId = _getUserId();
    try {
      final response = await _client
          .from('practice_attempts')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      developer.log(
        'Fetched recent practice attempts',
        name: 'SupabasePracticeDataSource',
      );
      // No need to check response == null, Supabase client handles this.
      final attempts =
          (response as List)
              .map(
                (data) =>
                    PracticeAttempt.fromJson(data as Map<String, dynamic>),
              )
              .toList();
      return attempts;
    } on PostgrestException catch (e) {
      developer.log(
        'Error fetching recent practice attempts: ${e.message}',
        error: e,
        name: 'SupabasePracticeDataSource',
      );
      throw ServerException(
        'Failed to fetch recent attempts: ${e.message}',
        e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      developer.log(
        'Unexpected error fetching recent practice attempts: $e',
        error: e,
        name: 'SupabasePracticeDataSource',
      );
      throw ServerException(
        'An unexpected error occurred while fetching recent attempts.',
      );
    }
  }

  @override
  Future<List<PracticeAttempt>> getAllPracticeAttempts() async {
    final userId = _getUserId();
    try {
      final response = await _client
          .from('practice_attempts')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      developer.log(
        'Fetched all practice attempts',
        name: 'SupabasePracticeDataSource',
      );
      final attempts =
          (response as List)
              .map(
                (data) =>
                    PracticeAttempt.fromJson(data as Map<String, dynamic>),
              )
              .toList();
      return attempts;
    } on PostgrestException catch (e) {
      developer.log(
        'Error fetching all practice attempts: ${e.message}',
        error: e,
        name: 'SupabasePracticeDataSource',
      );
      throw ServerException(
        'Failed to fetch attempts: ${e.message}',
        e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      developer.log(
        'Unexpected error fetching all practice attempts: $e',
        error: e,
        name: 'SupabasePracticeDataSource',
      );
      throw ServerException(
        'An unexpected error occurred while fetching attempts.',
      );
    }
  }

  // Helper function to calculate average accuracy from a list of attempts
  double _calculateAverage(List<dynamic> data) {
    if (data.isEmpty) {
      return 0.0;
    }
    final attempts =
        data
            .map(
              (item) => PracticeAttempt.fromJson(item as Map<String, dynamic>),
            )
            .toList();
    if (attempts.isEmpty) {
      return 0.0;
    }
    final double sum = attempts.fold(
      0.0,
      (prev, element) => prev + element.accuracy,
    );
    return sum / attempts.length;
  }

  @override
  Future<double> getWeeklyAverageAccuracy() async {
    final userId = _getUserId();
    try {
      final now = DateTime.now();
      // Calculate the date 7 days ago from the beginning of today
      final startOfWeek = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 6));

      final response = await _client
          .from('practice_attempts')
          .select('accuracy') // Only select accuracy
          .eq('user_id', userId)
          .gte(
            'created_at',
            startOfWeek.toIso8601String(),
          ); // Greater than or equal to start of week

      developer.log(
        'Fetched weekly accuracy data',
        name: 'SupabasePracticeDataSource',
      );
      return _calculateAverage(response as List);
    } on PostgrestException catch (e) {
      developer.log(
        'Error fetching weekly average accuracy: ${e.message}',
        error: e,
        name: 'SupabasePracticeDataSource',
      );
      throw ServerException(
        'Failed to fetch weekly accuracy: ${e.message}',
        e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      developer.log(
        'Unexpected error fetching weekly average accuracy: $e',
        error: e,
        name: 'SupabasePracticeDataSource',
      );
      throw ServerException(
        'An unexpected error occurred while fetching weekly accuracy.',
      );
    }
  }

  @override
  Future<double> getOverallAverageAccuracy() async {
    final userId = _getUserId();
    try {
      // Supabase Edge Functions might be better for direct AVG calculation,
      // but fetching all and calculating client-side is simpler for now.
      final response = await _client
          .from('practice_attempts')
          .select('accuracy') // Only select accuracy
          .eq('user_id', userId);

      developer.log(
        'Fetched overall accuracy data',
        name: 'SupabasePracticeDataSource',
      );
      return _calculateAverage(response as List);
    } on PostgrestException catch (e) {
      developer.log(
        'Error fetching overall average accuracy: ${e.message}',
        error: e,
        name: 'SupabasePracticeDataSource',
      );
      throw ServerException(
        'Failed to fetch overall accuracy: ${e.message}',
        e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      developer.log(
        'Unexpected error fetching overall average accuracy: $e',
        error: e,
        name: 'SupabasePracticeDataSource',
      );
      throw ServerException(
        'An unexpected error occurred while fetching overall accuracy.',
      );
    }
  }
}

// Provider for the PracticeDataSource implementation
final supabasePracticeDataSourceProvider = Provider<PracticeDataSource>((ref) {
  // Use ref.watch for Supabase client as it might change (e.g., auth state)
  final client = ref.watch(supabaseClientProvider);
  return SupabasePracticeDataSource(client);
});

// Provider for Supabase client (assuming it's defined elsewhere, e.g., core/providers)
// If not, define it here or in a central providers file.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  // This assumes Supabase is initialized elsewhere and accessible.
  return Supabase.instance.client;
});

// === Add Providers for Data Fetching ===

final recentPracticeAttemptsProvider =
    FutureProvider.autoDispose<List<PracticeAttempt>>((ref) {
      final dataSource = ref.watch(supabasePracticeDataSourceProvider);
      // Optionally pass a limit, or use the default
      return dataSource.getRecentPracticeAttempts();
    });

final allPracticeAttemptsProvider =
    FutureProvider.autoDispose<List<PracticeAttempt>>((ref) {
      final dataSource = ref.watch(supabasePracticeDataSourceProvider);
      return dataSource.getAllPracticeAttempts();
    });

final weeklyPracticeAccuracyProvider = FutureProvider.autoDispose<double>((
  ref,
) {
  final dataSource = ref.watch(supabasePracticeDataSourceProvider);
  return dataSource.getWeeklyAverageAccuracy();
});

final overallPracticeAccuracyProvider = FutureProvider.autoDispose<double>((
  ref,
) {
  final dataSource = ref.watch(supabasePracticeDataSourceProvider);
  return dataSource.getOverallAverageAccuracy();
});
