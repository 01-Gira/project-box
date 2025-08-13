part of 'dashboard_stats_bloc.dart';

abstract class DashboardStatsEvent extends Equatable {
  const DashboardStatsEvent();

  @override
  List<Object> get props => [];
}

class FetchDashboardStats extends DashboardStatsEvent {}
