import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/data/repositories/profile_repository.dart';
import 'package:alarp/features/challenge/models/challenge_attempt.dart';
import 'package:alarp/core/providers/guest_mode_provider.dart';

final challengeHistoryProvider = FutureProvider.autoDispose<
  List<ChallengeAttempt>
>((ref) async {
  if (ref.watch(guestModeProvider)) return DemoData.challengeHistory;
  try {
    final repository = ref.watch(profileRepositoryProvider);
    return await repository.getChallengeHistory(limit: 50);
  } catch (_) {
    rethrow;
  }
}, name: 'challengeHistoryProvider');
