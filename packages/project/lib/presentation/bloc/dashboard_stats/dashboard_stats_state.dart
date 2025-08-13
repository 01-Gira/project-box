part of 'dashboard_stats_bloc.dart';

class DashboardStatsState extends Equatable {
  final RequestState state;
  final String message;
  final DashboardStats? stats;

  const DashboardStatsState({
    this.state = RequestState.empty,
    this.message = '',
    this.stats,
  });

  DashboardStatsState copyWith({
    RequestState? state,
    String? message,
    DashboardStats? stats,
  }) {
    return DashboardStatsState(
      state: state ?? this.state,
      message: message ?? this.message,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [state, message, stats];
}
