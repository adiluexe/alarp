import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/data/repositories/profile_repository.dart'; // Access repository
import 'package:alarp/features/challenge/models/challenge_attempt.dart'; // Access model

// Provider to fetch the challenge history list for the current user
final challengeHistoryProvider = FutureProvider.autoDispose<
  List<ChallengeAttempt>
>((ref) async {
  print("[ChallengeHistoryProvider] Fetching challenge history...");
  try {
    // Watch the repository provider to get an instance of ProfileRepository
    final repository = ref.watch(profileRepositoryProvider);
    // Call the repository method to fetch the history data
    final historyData = await repository.getChallengeHistory(
      limit: 50,
    ); // Fetch last 50 attempts
    print(
      "[ChallengeHistoryProvider] Fetched data: ${historyData.length} entries",
    );
    return historyData;
  } catch (e, stackTrace) {
    print("[ChallengeHistoryProvider] Error fetching challenge history: $e");
    print("[ChallengeHistoryProvider] Stack Trace: $stackTrace");
    // Re-throw the error so the UI can handle the error state
    rethrow;
  }
}, name: 'challengeHistoryProvider');
