class Datum {
  int? teacherId;
  int? userId;
  String? name;
  String? email;
  String? subjectName;
  int? subjectId;
  int? classSectionId;

  Datum({
    this.teacherId,
    this.userId,
    this.name,
    this.email,
    this.subjectName,
    this.subjectId,
    this.classSectionId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        teacherId: json['teacher_id'] as int?,
        userId: json['user_id'] as int?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        subjectName: json['subject_name'] as String?,
        subjectId: json['subject_id'] as int?,
        classSectionId: json['class_section_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'teacher_id': teacherId,
        'user_id': userId,
        'name': name,
        'email': email,
        'subject_name': subjectName,
        'subject_id': subjectId,
        'class_section_id': classSectionId,
      };
}
