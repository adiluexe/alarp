import 'package:alarp/core/error/failures.dart';
import 'package:alarp/data/datasources/supabase_practice_datasource.dart';
import 'package:alarp/features/practice/models/practice_attempt.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/core/error/exceptions.dart';
import 'dart:developer' as developer; // Use developer log

// Interface for the Practice Repository
abstract class PracticeRepository {
  Future<Either<Failure, void>> addPracticeAttempt({
    required String bodyPartId,
    required String projectionName,
    required double accuracy,
  });

  Future<Either<Failure, List<PracticeAttempt>>> getRecentPracticeAttempts({
    int limit = 5,
  });

  Future<Either<Failure, List<PracticeAttempt>>> getAllPracticeAttempts();

  Future<Either<Failure, double>> getWeeklyAverageAccuracy();

  Future<Either<Failure, double>> getOverallAverageAccuracy();
}

// Implementation using SupabasePracticeDataSource
class SupabasePracticeRepository implements PracticeRepository {
  final PracticeDataSource _dataSource;

  SupabasePracticeRepository(this._dataSource);

  // Helper to execute data source calls and handle exceptions/failures
  Future<Either<Failure, T>> _tryCatch<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on ServerException catch (e) {
      developer.log(
        'ServerException in Repository: ${e.message}',
        error: e,
        name: 'SupabasePracticeRepository',
      );
      return Left(ServerFailure(e.message, e.statusCode));
    } on AuthException catch (e) {
      developer.log(
        'AuthException in Repository: ${e.message}',
        error: e,
        name: 'SupabasePracticeRepository',
      );
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      developer.log(
        'Unexpected error in Repository: $e',
        error: e,
        name: 'SupabasePracticeRepository',
      );
      return Left(
        UnknownFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addPracticeAttempt({
    required String bodyPartId,
    required String projectionName,
    required double accuracy,
  }) async {
    return _tryCatch(
      () => _dataSource.addPracticeAttempt(
        bodyPartId: bodyPartId,
        projectionName: projectionName,
        accuracy: accuracy,
      ),
    );
  }

  @override
  Future<Either<Failure, List<PracticeAttempt>>> getRecentPracticeAttempts({
    int limit = 5,
  }) async {
    return _tryCatch(() => _dataSource.getRecentPracticeAttempts(limit: limit));
  }

  @override
  Future<Either<Failure, List<PracticeAttempt>>>
  getAllPracticeAttempts() async {
    return _tryCatch(() => _dataSource.getAllPracticeAttempts());
  }

  @override
  Future<Either<Failure, double>> getWeeklyAverageAccuracy() async {
    return _tryCatch(() => _dataSource.getWeeklyAverageAccuracy());
  }

  @override
  Future<Either<Failure, double>> getOverallAverageAccuracy() async {
    return _tryCatch(() => _dataSource.getOverallAverageAccuracy());
  }
}

// Provider for the PracticeRepository implementation
final practiceRepositoryProvider = Provider<PracticeRepository>((ref) {
  // Depend on the abstract PracticeDataSource provider
  final datasource = ref.watch(supabasePracticeDataSourceProvider);
  return SupabasePracticeRepository(datasource);
});

// --- Data Fetching Providers ---

// Provider to fetch recent practice attempts
final recentPracticeAttemptsProvider =
    FutureProvider.autoDispose<List<PracticeAttempt>>((ref) async {
      // Use autoDispose
      final repository = ref.watch(practiceRepositoryProvider);
      // Fetch slightly more for the "view all" case, can be limited in UI
      final result = await repository.getRecentPracticeAttempts(limit: 10);
      return result.fold((failure) {
        developer.log(
          'Error fetching recent attempts: ${failure.message}',
          error: failure,
          name: 'recentPracticeAttemptsProvider',
        );
        // Propagate the failure; UI should handle AsyncError
        throw failure;
      }, (attempts) => attempts);
    });

// Provider to fetch all practice attempts
final allPracticeAttemptsProvider =
    FutureProvider.autoDispose<List<PracticeAttempt>>((ref) async {
      // Use autoDispose
      final repository = ref.watch(practiceRepositoryProvider);
      final result = await repository.getAllPracticeAttempts();
      return result.fold((failure) {
        developer.log(
          'Error fetching all attempts: ${failure.message}',
          error: failure,
          name: 'allPracticeAttemptsProvider',
        );
        throw failure; // Propagate the failure
      }, (attempts) => attempts);
    });

// Provider to fetch weekly average accuracy
final weeklyAccuracyProvider = FutureProvider.autoDispose<double>((ref) async {
  // Use autoDispose
  final repository = ref.watch(practiceRepositoryProvider);
  final result = await repository.getWeeklyAverageAccuracy();
  return result.fold((failure) {
    developer.log(
      'Error fetching weekly accuracy: ${failure.message}',
      error: failure,
      name: 'weeklyAccuracyProvider',
    );
    return 0.0; // Default to 0 on failure for display
  }, (avg) => avg);
});

// Provider to fetch overall average accuracy
final overallAccuracyProvider = FutureProvider.autoDispose<double>((ref) async {
  // Use autoDispose
  final repository = ref.watch(practiceRepositoryProvider);
  final result = await repository.getOverallAverageAccuracy();
  return result.fold((failure) {
    developer.log(
      'Error fetching overall accuracy: ${failure.message}',
      error: failure,
      name: 'overallAccuracyProvider',
    );
    return 0.0; // Default to 0 on failure for display
  }, (avg) => avg);
});
