import 'data.dart';

class TeacherEvaluationModel {
  bool? error;
  String? message;
  Data? data;
  int? code;

  TeacherEvaluationModel({this.error, this.message, this.data, this.code});

  factory TeacherEvaluationModel.fromJson(Map<String, dynamic> json) {
    return TeacherEvaluationModel(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      code: json['code'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
        'data': data?.toJson(),
        'code': code,
      };
}
