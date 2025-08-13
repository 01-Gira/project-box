import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:progress_log/domain/entities/progress_log.dart';
import 'package:progress_log/domain/repositories/progress_log_repository.dart';

class SaveProgressLog {
  final ProgressLogRepository repository;
  SaveProgressLog(this.repository);

  Future<Either<Failure, String>> call({
    required int projectId,
    required ProgressLog log,
  }) {
    return repository.saveProgressLog(projectId: projectId, log: log);
  }
}
