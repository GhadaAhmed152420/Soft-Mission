import 'package:eschool/ui/screens/teachers_evaluation/models/teacher_evaluation_model/teacher_evaluation_model.dart';
import 'package:eschool/ui/screens/teachers_evaluation/models/teachers_model/teachers_model.dart';

import 'package:eschool/utils/api.dart';

class TeachersEvaluationRepo {
  Future<TeachersModel> getTeachers({required int childId}) async {
    try {
      final result = await Api.get(
          url: "${Api.teachersParentUrl}?child_id=$childId",
          useAuthToken: true);

      return TeachersModel.fromJson(result);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<TeacherEvaluationModel> storeWeeksReports({
    required int childId,
    required String date,
    required int teacherId,
    required int subjectId,
    required int classSectionId,
    required int explanation,
    required int homeworkFollowUp,
    required int punctuality,
    required int individualDifferences,
    required int interAction,
  }) async {
    try {
      final result = await Api.post(
        body: {},
        url:
            "${Api.teachersEvaluationsParentUrl}?child_id=$childId&teacher_id=$teacherId&subject_id=$subjectId&class_section_id=$classSectionId&date=$date&explanation=$explanation&homework_followup=$homeworkFollowUp&punctuality=$punctuality&individual_differences=$individualDifferences&interaction=$interAction",
        useAuthToken: true,
      );

      return TeacherEvaluationModel.fromJson(result);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
