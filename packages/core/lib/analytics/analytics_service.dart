import 'dart:math';

/// Provides simple analytics calculations for dashboard metrics.
class AnalyticsService {
  const AnalyticsService();

  /// Calculate remaining tasks for a burn‑down chart.
  ///
  /// [totalTasks] is the current total number of tasks and
  /// [dailyCompletions] are tasks completed for each day (oldest first).
  /// Returns a list with the remaining tasks after each day.
  List<int> calculateBurnDown(int totalTasks, List<int> dailyCompletions) {
    final remaining = <int>[];
    var current = totalTasks;
    for (final completed in dailyCompletions) {
      current = max(0, current - completed);
      remaining.add(current);
    }
    return remaining;
  }

  /// Calculate average task completion velocity per day.
  double calculateVelocity(List<int> dailyCompletions) {
    if (dailyCompletions.isEmpty) return 0;
    final total = dailyCompletions.fold<int>(0, (a, b) => a + b);
    return total / dailyCompletions.length;
  }
}
