import 'datum.dart';

class WeeklyReportsModel {
  bool? error;
  List<Datum>? data;
  int? code;

  WeeklyReportsModel({this.error, this.data, this.code});

  factory WeeklyReportsModel.fromJson(Map<String, dynamic> json) {
    return WeeklyReportsModel(
      error: json['error'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      code: json['code'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'error': error,
        'data': data?.map((e) => e.toJson()).toList(),
        'code': code,
      };
}
