class Datum {
  String? subjectName;
  String? evaluationDate;
  int? attendance;
  int? participation;
  int? homework;
  int? studentLevel;

  Datum({
    this.subjectName,
    this.evaluationDate,
    this.attendance,
    this.participation,
    this.homework,
    this.studentLevel,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        subjectName: json['subject_name'] as String?,
        evaluationDate: json['evaluation_date'] as String?,
        attendance: json['attendance'] as int?,
        participation: json['participation'] as int?,
        homework: json['homework'] as int?,
        studentLevel: json['student_level'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'subject_name': subjectName,
        'evaluation_date': evaluationDate,
        'attendance': attendance,
        'participation': participation,
        'homework': homework,
        'student_level': studentLevel,
      };
}
