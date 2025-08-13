import 'package:core/data/datasources/db/database_helper.dart';
import 'package:progress_log/data/models/progress_log_table.dart';
import 'package:core/common/exception.dart';

abstract class ProgressLogLocalDataSource {
  Future<String> insertProgressLog({
    required int projectId,
    required ProgressLogTable log,
  });
  Future<List<ProgressLogTable>> getProgressLogsForProject(int id);
  Future<String> updateProgressLog({
    required int logId,
    required ProgressLogTable log,
  });
  Future<String> removeProgressLog(int logId);
}

class ProgressLogLocalDataSourceImpl implements ProgressLogLocalDataSource {
  final DatabaseHelper helper;

  ProgressLogLocalDataSourceImpl({required this.helper});

  @override
  Future<List<ProgressLogTable>> getProgressLogsForProject(int id) async {
    try {
      final result = await helper.getProgressLogsForProject(id);
      return result.map((data) => ProgressLogTable.fromMap(data)).toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> insertProgressLog({
    required int projectId,
    required ProgressLogTable log,
  }) async {
    try {
      await helper.insertProgressLog(projectId, log.toJson());

      return 'Added to project';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> updateProgressLog({
    required int logId,
    required ProgressLogTable log,
  }) async {
    try {
      await helper.updateProgressLog(logId, log.toJson());

      return 'Progress Log updated';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeProgressLog(int logId) async {
    try {
      await helper.deleteProgressLog(logId);

      return 'Progress Log deleted';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
