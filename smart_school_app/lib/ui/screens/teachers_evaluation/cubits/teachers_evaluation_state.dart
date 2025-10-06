part of 'teachers_evaluation_cubit.dart';

@immutable
sealed class TeachersEvaluationState {}

final class TeachersEvaluationInitial extends TeachersEvaluationState {}

final class GetTeachersLoading extends TeachersEvaluationState {}

final class GetTeachersSuccess extends TeachersEvaluationState {
  final TeachersModel teachersModel;

  GetTeachersSuccess({required this.teachersModel});
}

final class GetTeachersFailure extends TeachersEvaluationState {
  final String error;

  GetTeachersFailure({required this.error});
}

final class StoreTeachersEvaluationLoading extends TeachersEvaluationState {}

final class StoreTeachersEvaluationSuccess extends TeachersEvaluationState {
  final TeacherEvaluationModel teacherEvaluationModel;

  StoreTeachersEvaluationSuccess({required this.teacherEvaluationModel});
}

final class StoreTeachersEvaluationFailure extends TeachersEvaluationState {
  final String error;

  StoreTeachersEvaluationFailure({required this.error});
}
