import 'package:eschool/ui/screens/weekly_report/models/week_evalutions_model/week_evalutions_model.dart';
import 'package:eschool/ui/screens/weekly_report/models/weekly_reports_model/weekly_reports_model.dart';

import 'package:eschool/utils/api.dart';

class WeeklyReportRepository {
  Future<WeeksModel> getWeeks(
      {required int childId,
      required int month,
      required bool isParent}) async {
    try {
      final result = await Api.get(
          url: isParent
              ? "${Api.weeksParentUrl}?child_id=$childId&month=$month"
              : "${Api.weeksStudentUrl}?month=$month",
          useAuthToken: true);

      return WeeksModel.fromJson(result);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<WeeklyReportsModel> getWeeksReports(
      {required int childId,
      required String date,
      required bool isParent}) async {
    try {
      final result = await Api.get(
          url: isParent
              ? "${Api.weeklyParentReportsUrl}?child_id=$childId&date=$date"
              : "${Api.weeklyStudentReportsUrl}?date=$date",
          useAuthToken: true);

      return WeeklyReportsModel.fromJson(result);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
