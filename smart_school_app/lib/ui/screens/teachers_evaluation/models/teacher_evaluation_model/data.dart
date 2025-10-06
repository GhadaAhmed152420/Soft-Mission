class Data {
  int? parentId;
  String? studentId;
  String? teacherId;
  String? subjectId;
  String? classSectionId;
  String? sessionYearId;
  String? evaluationDate;
  String? explanation;
  String? homeworkFollowup;
  String? punctuality;
  String? individualDifferences;
  String? interaction;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({
    this.parentId,
    this.studentId,
    this.teacherId,
    this.subjectId,
    this.classSectionId,
    this.sessionYearId,
    this.evaluationDate,
    this.explanation,
    this.homeworkFollowup,
    this.punctuality,
    this.individualDifferences,
    this.interaction,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        parentId: json['parent_id'] as int?,
        studentId: json['student_id'] as String?,
        teacherId: json['teacher_id'] as String?,
        subjectId: json['subject_id'] as String?,
        classSectionId: json['class_section_id'] as String?,
        sessionYearId: json['session_year_id'] as String?,
        evaluationDate: json['evaluation_date'] as String?,
        explanation: json['explanation'] as String?,
        homeworkFollowup: json['homework_followup'] as String?,
        punctuality: json['punctuality'] as String?,
        individualDifferences: json['individual_differences'] as String?,
        interaction: json['interaction'] as String?,
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        id: json['id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'parent_id': parentId,
        'student_id': studentId,
        'teacher_id': teacherId,
        'subject_id': subjectId,
        'class_section_id': classSectionId,
        'session_year_id': sessionYearId,
        'evaluation_date': evaluationDate,
        'explanation': explanation,
        'homework_followup': homeworkFollowup,
        'punctuality': punctuality,
        'individual_differences': individualDifferences,
        'interaction': interaction,
        'updated_at': updatedAt?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
        'id': id,
      };
}
