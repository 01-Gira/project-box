import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final int completedProjects;
  final int totalTasksDone;
  final int productiveStreak;

  const DashboardStats({
    required this.completedProjects,
    required this.totalTasksDone,
    required this.productiveStreak,
  });

  @override
  List<Object?> get props => [
    completedProjects,
    totalTasksDone,
    productiveStreak,
  ];
}
