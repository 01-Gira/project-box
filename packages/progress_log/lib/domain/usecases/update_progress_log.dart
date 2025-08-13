import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:progress_log/domain/entities/progress_log.dart';
import 'package:progress_log/domain/repositories/progress_log_repository.dart';

class UpdateProgressLog {
  final ProgressLogRepository repository;
  UpdateProgressLog(this.repository);

  Future<Either<Failure, String>> call({
    required int logId,
    required ProgressLog log,
  }) {
    return repository.updateProgressLog(logId: logId, log: log);
  }
}
