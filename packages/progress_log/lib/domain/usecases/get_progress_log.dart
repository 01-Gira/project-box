import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:progress_log/domain/entities/progress_log.dart';
import 'package:progress_log/domain/repositories/progress_log_repository.dart';

class GetProgressLog {
  final ProgressLogRepository repository;

  GetProgressLog(this.repository);

  Future<Either<Failure, List<ProgressLog>>> call(int id) {
    return repository.getLogsForProject(id);
  }
}
