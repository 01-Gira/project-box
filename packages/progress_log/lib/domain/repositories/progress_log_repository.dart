import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:progress_log/domain/entities/progress_log.dart';

abstract class ProgressLogRepository {
  Future<Either<Failure, List<ProgressLog>>> getLogsForProject(int id);
  Future<Either<Failure, String>> saveProgressLog({
    required int projectId,
    required ProgressLog log,
  });
  Future<Either<Failure, String>> removeProgressLog(int logId);
  Future<Either<Failure, String>> updateProgressLog({
    required int logId,
    required ProgressLog log,
  });
}
