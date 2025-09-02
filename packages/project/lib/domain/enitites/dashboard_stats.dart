import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final int completedProjects;
  final int totalTasksDone;
  final int productiveStreak;
  final List<int> dailyTaskCompletions;
  final List<int> burnDownData;
  final double velocity;

  const DashboardStats({
    required this.completedProjects,
    required this.totalTasksDone,
    required this.productiveStreak,
    required this.dailyTaskCompletions,
    required this.burnDownData,
    required this.velocity,
  });

  @override
  List<Object?> get props => [
    completedProjects,
    totalTasksDone,
    productiveStreak,
    dailyTaskCompletions,
    burnDownData,
    velocity,
  ];
}
