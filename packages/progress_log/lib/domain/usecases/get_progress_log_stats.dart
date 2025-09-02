import 'package:progress_log/domain/entities/progress_log.dart';

class GetProgressLogStats {
  Map<DateTime, int> call(List<ProgressLog> logs) {
    final Map<DateTime, int> stats = {};
    for (final log in logs) {
      final date = log.logDate;
      if (date != null) {
        final day = DateTime(date.year, date.month, date.day);
        stats.update(day, (value) => value + 1, ifAbsent: () => 1);
      }
    }
    return stats;
  }
}
