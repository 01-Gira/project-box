import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final int completedProjects;
  final int totalTasksDone;
  final int productiveStreak;
  final List<int> dailyTaskCompletions;

  const DashboardStats({
    required this.completedProjects,
    required this.totalTasksDone,
    required this.productiveStreak,
    required this.dailyTaskCompletions,
  });

  @override
  List<Object?> get props => [
    completedProjects,
    totalTasksDone,
    productiveStreak,
    dailyTaskCompletions,
  ];
}
