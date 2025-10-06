import 'package:bloc/bloc.dart';
import 'package:eschool/ui/screens/weekly_report/models/week_evalutions_model/week_evalutions_model.dart';
import 'package:eschool/ui/screens/weekly_report/models/weekly_reports_model/weekly_reports_model.dart';
import 'package:eschool/ui/screens/weekly_report/repositories/weekly_report_repo.dart';
import 'package:meta/meta.dart';

part 'weekly_state.dart';

class WeeklyCubit extends Cubit<WeeklyState> {
  WeeklyCubit(this.weeklyReportRepository) : super(WeeklyInitial());
  WeeklyReportRepository weeklyReportRepository;

  Future<void> fetchWeeks({
    required int? childId,
    required int month,
    required bool isParent,
  }) async {
    try {
      emit(GetWeeksLoading());
      final result = await weeklyReportRepository.getWeeks(
        isParent: isParent,
        month: month,
        childId: childId ?? 0,
      );
      emit(GetWeeksSuccess(weeksModel: result));
    } catch (e) {
      emit(GetWeeksFailure(errorMessage: e.toString()));
    }
  }

  Future<void> fetchWeeklyReports({
    required int? childId,
    required String date,
    required bool isParent,
  }) async {
    try {
      emit(GetWeeklyReportsLoading());
      final result = await weeklyReportRepository.getWeeksReports(
        isParent: isParent,
        childId: childId ?? 0,
        date: date,
      );
      emit(GetWeeklyReportsSuccess(weeklyReportsModel: result));
    } catch (e) {
      emit(GetWeeklyReportsFailure(errorMessage: e.toString()));
    }
  }
}
