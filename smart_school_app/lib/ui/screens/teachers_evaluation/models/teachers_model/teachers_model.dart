import 'datum.dart';

class TeachersModel {
  bool? error;
  String? message;
  List<Datum>? data;
  int? code;

  TeachersModel({this.error, this.message, this.data, this.code});

  factory TeachersModel.fromJson(Map<String, dynamic> json) => TeachersModel(
        error: json['error'] as bool?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
            .toList(),
        code: json['code'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
        'code': code,
      };
}
