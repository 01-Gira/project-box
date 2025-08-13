import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:progress_log/domain/repositories/progress_log_repository.dart';

class RemoveProgressLog {
  final ProgressLogRepository repository;
  RemoveProgressLog(this.repository);

  Future<Either<Failure, String>> call(int logId) {
    return repository.removeProgressLog(logId);
  }
}
