import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/features/practice/models/practice_attempt.dart';
import 'package:alarp/features/challenge/models/challenge_attempt.dart';
import 'package:alarp/data/datasources/supabase_profile_datasource.dart'
    show LeaderboardEntry;

/// Tracks whether the app is running in guest/demo mode.
final guestModeProvider = StateProvider<bool>((ref) => false);

/// All static demo data used when running in guest mode.
class DemoData {
  static const Map<String, dynamic> userProfile = {
    'first_name': 'Demo',
    'last_name': 'User',
    'username': 'demo_user',
    'current_streak': 7,
    'total_app_time_seconds': 10800, // 3 hours
    'email': 'demo@alarp.app',
  };

  static List<PracticeAttempt> get practiceAttempts {
    final now = DateTime.now();
    final entries = [
      (part: 'hand', proj: 'PA', acc: 55.0, days: 14, h: 0),
      (part: 'wrist', proj: 'PA', acc: 61.0, days: 13, h: 2),
      (part: 'hand', proj: 'Oblique', acc: 58.0, days: 13, h: 6),
      (part: 'forearm', proj: 'AP', acc: 64.0, days: 12, h: 1),
      (part: 'elbow', proj: 'AP', acc: 67.0, days: 11, h: 3),
      (part: 'wrist', proj: 'Lateral', acc: 70.0, days: 11, h: 8),
      (part: 'hand', proj: 'PA', acc: 72.0, days: 10, h: 2),
      (part: 'shoulder', proj: 'AP', acc: 65.0, days: 9, h: 4),
      (part: 'humerus', proj: 'AP', acc: 68.0, days: 8, h: 1),
      (part: 'elbow', proj: 'Lateral', acc: 74.0, days: 7, h: 5),
      (part: 'forearm', proj: 'Lateral', acc: 76.0, days: 6, h: 2),
      (part: 'wrist', proj: 'PA', acc: 79.0, days: 5, h: 3),
      (part: 'hand', proj: 'Oblique', acc: 81.0, days: 5, h: 7),
      (part: 'elbow', proj: 'AP', acc: 83.0, days: 4, h: 1),
      (part: 'shoulder', proj: 'AP', acc: 80.0, days: 3, h: 4),
      (part: 'humerus', proj: 'Lateral', acc: 85.0, days: 3, h: 9),
      (part: 'wrist', proj: 'Oblique', acc: 82.0, days: 2, h: 2),
      (part: 'forearm', proj: 'AP', acc: 87.0, days: 2, h: 6),
      (part: 'elbow', proj: 'Lateral', acc: 89.0, days: 1, h: 3),
      (part: 'hand', proj: 'PA', acc: 93.0, days: 0, h: 1),
    ];
    return entries.asMap().entries.map((e) {
      return PracticeAttempt(
        id: 'demo_${e.key}',
        userId: 'demo_user',
        bodyPartId: e.value.part,
        projectionName: e.value.proj,
        accuracy: e.value.acc,
        createdAt: now.subtract(
          Duration(days: e.value.days, hours: e.value.h),
        ),
      );
    }).toList();
  }

  static List<ChallengeAttempt> get challengeHistory {
    final now = DateTime.now();
    return [
      ChallengeAttempt(
        id: 'demo_ch_1',
        userId: 'demo_user',
        challengeId: 'upper_extremities_10rounds',
        challengeTitle: 'Upper Extremities',
        completedAt: now.subtract(const Duration(hours: 2)),
        score: 870,
        stepResults: [],
      ),
      ChallengeAttempt(
        id: 'demo_ch_2',
        userId: 'demo_user',
        challengeId: 'upper_extremities_10rounds',
        challengeTitle: 'Upper Extremities',
        completedAt: now.subtract(const Duration(days: 1, hours: 5)),
        score: 790,
        stepResults: [],
      ),
      ChallengeAttempt(
        id: 'demo_ch_3',
        userId: 'demo_user',
        challengeId: 'upper_extremities_10rounds',
        challengeTitle: 'Upper Extremities',
        completedAt: now.subtract(const Duration(days: 3)),
        score: 720,
        stepResults: [],
      ),
      ChallengeAttempt(
        id: 'demo_ch_4',
        userId: 'demo_user',
        challengeId: 'upper_extremities_10rounds',
        challengeTitle: 'Upper Extremities',
        completedAt: now.subtract(const Duration(days: 5, hours: 8)),
        score: 650,
        stepResults: [],
      ),
      ChallengeAttempt(
        id: 'demo_ch_5',
        userId: 'demo_user',
        challengeId: 'upper_extremities_10rounds',
        challengeTitle: 'Upper Extremities',
        completedAt: now.subtract(const Duration(days: 7, hours: 3)),
        score: 580,
        stepResults: [],
      ),
    ];
  }

  static List<LeaderboardEntry> get leaderboardToday => [
        (rank: 1, username: 'Santos, M.', score: 950),
        (rank: 2, username: 'Demo, User', score: 870),
        (rank: 3, username: 'Cruz, A.', score: 830),
        (rank: 4, username: 'Reyes, J.', score: 780),
        (rank: 5, username: 'Garcia, L.', score: 740),
        (rank: 6, username: 'Torres, C.', score: 710),
        (rank: 7, username: 'Dela Cruz, R.', score: 680),
      ];

  static List<LeaderboardEntry> get leaderboardAllTime => [
        (rank: 1, username: 'Santos, M.', score: 9850),
        (rank: 2, username: 'Cruz, A.', score: 8920),
        (rank: 3, username: 'Demo, User', score: 8610),
        (rank: 4, username: 'Reyes, J.', score: 7780),
        (rank: 5, username: 'Garcia, L.', score: 7240),
        (rank: 6, username: 'Torres, C.', score: 6910),
        (rank: 7, username: 'Dela Cruz, R.', score: 6480),
      ];

  static double get weeklyAccuracy => 82.0;
  static double get overallAccuracy => 75.0;
}
