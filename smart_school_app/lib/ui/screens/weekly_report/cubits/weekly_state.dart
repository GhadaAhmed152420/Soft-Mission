part of 'weekly_cubit.dart';

@immutable
sealed class WeeklyState {}

final class WeeklyInitial extends WeeklyState {}

final class GetWeeksLoading extends WeeklyState {}

final class GetWeeksFailure extends WeeklyState {
  final String errorMessage;

  GetWeeksFailure({required this.errorMessage});
}

final class GetWeeksSuccess extends WeeklyState {
  final WeeksModel weeksModel;

  GetWeeksSuccess({required this.weeksModel});
}

final class GetWeeklyReportsLoading extends WeeklyState {}

final class GetWeeklyReportsFailure extends WeeklyState {
  final String errorMessage;

  GetWeeklyReportsFailure({required this.errorMessage});
}

final class GetWeeklyReportsSuccess extends WeeklyState {
  final WeeklyReportsModel weeklyReportsModel;

  GetWeeklyReportsSuccess({required this.weeklyReportsModel});
}
