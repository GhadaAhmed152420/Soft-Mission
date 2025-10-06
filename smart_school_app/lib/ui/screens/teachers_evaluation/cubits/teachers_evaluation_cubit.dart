import 'package:bloc/bloc.dart';
import 'package:eschool/ui/screens/teachers_evaluation/models/teacher_evaluation_model/teacher_evaluation_model.dart';
import 'package:eschool/ui/screens/teachers_evaluation/models/teachers_model/teachers_model.dart';
import 'package:eschool/ui/screens/teachers_evaluation/repositories/teachers_evaluation_repo.dart';
import 'package:meta/meta.dart';

part 'teachers_evaluation_state.dart';

class TeachersEvaluationCubit extends Cubit<TeachersEvaluationState> {
  TeachersEvaluationCubit(this.teachersEvaluationRepo)
      : super(TeachersEvaluationInitial());
  TeachersEvaluationRepo teachersEvaluationRepo;

  Future<void> fetchTeachers({
    required int? childId,
  }) async {
    try {
      emit(GetTeachersLoading());
      final result = await teachersEvaluationRepo.getTeachers(
        childId: childId ?? 0,
      );
      emit(GetTeachersSuccess(teachersModel: result));
    } catch (e) {
      emit(GetTeachersFailure(error: e.toString()));
    }
  }

  Future<void> storeEvaluation({
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
      emit(StoreTeachersEvaluationLoading());
      final result = await teachersEvaluationRepo.storeWeeksReports(
        childId: childId,
        date: date,
        teacherId: teacherId,
        subjectId: subjectId,
        classSectionId: classSectionId,
        explanation: explanation,
        homeworkFollowUp: homeworkFollowUp,
        punctuality: punctuality,
        individualDifferences: individualDifferences,
        interAction: interAction,
      );
      emit(StoreTeachersEvaluationSuccess(teacherEvaluationModel: result));
    } catch (e) {
      emit(StoreTeachersEvaluationFailure(error: e.toString()));
    }
  }
}
