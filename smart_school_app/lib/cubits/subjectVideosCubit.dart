import 'package:equatable/equatable.dart';
import 'package:eschool/data/models/studyMaterial.dart';
import 'package:eschool/data/repositories/subjectRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubjectVideosState extends Equatable {}

class SubjectVideosInitial extends SubjectVideosState {
  @override
  List<Object?> get props => [];
}

class SubjectVideosFetchInProgress extends SubjectVideosState {
  @override
  List<Object?> get props => [];
}

class SubjectVideosFetchSuccess extends SubjectVideosState {
  final List<StudyMaterial> videos;

  SubjectVideosFetchSuccess({required this.videos});
  @override
  List<Object?> get props => [videos];
}

class SubjectVideosFetchFailure extends SubjectVideosState {
  final String errorMessage;

  SubjectVideosFetchFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class SubjectVideosCubit extends Cubit<SubjectVideosState> {
  final SubjectRepository _subjectRepository;

  SubjectVideosCubit(this._subjectRepository) : super(SubjectVideosInitial());

  void fetchSubjectVideos({
    required int subjectId,
    required bool useParentApi,
    int? childId,
  }) {
    emit(SubjectVideosFetchInProgress());
    _subjectRepository
        .getVideos(
          subjectId: subjectId,
          childId: childId ?? 0,
          useParentApi: useParentApi,
        )
        .then((videos) => emit(SubjectVideosFetchSuccess(videos: videos)))
        .catchError((e) => emit(SubjectVideosFetchFailure(e.toString())));
  }
}
