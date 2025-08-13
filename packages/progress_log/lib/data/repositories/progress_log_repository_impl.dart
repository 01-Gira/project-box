import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:progress_log/data/datasources/progress_log_local_data_source.dart';
import 'package:progress_log/data/models/progress_log_table.dart';
import 'package:progress_log/domain/entities/progress_log.dart';
import 'package:progress_log/domain/repositories/progress_log_repository.dart';

class ProgressLogRepositoryImpl implements ProgressLogRepository {
  final ProgressLogLocalDataSource localDataSource;

  ProgressLogRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ProgressLog>>> getLogsForProject(int id) async {
    try {
      final result = await localDataSource.getProgressLogsForProject(id);
      return Right(result.map((data) => data.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveProgressLog({
    required int projectId,
    required ProgressLog log,
  }) async {
    try {
      final logTable = ProgressLogTable.fromEntity(log);
      final result = await localDataSource.insertProgressLog(
        projectId: projectId,
        log: logTable,
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> updateProgressLog({
    required int logId,
    required ProgressLog log,
  }) async {
    try {
      final logTable = ProgressLogTable.fromEntity(log);
      final result = await localDataSource.updateProgressLog(
        logId: logId,
        log: logTable,
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> removeProgressLog(int logId) async {
    try {
      final result = await localDataSource.removeProgressLog(logId);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
