import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:project/domain/enitites/dashboard_stats.dart';
import 'package:project/domain/repositories/project_repository.dart';

class GetDashboardStats {
  final ProjectRepository repository;

  GetDashboardStats(this.repository);

  Future<Either<Failure, DashboardStats>> call() {
    return repository.getDashboardStats();
  }
}
