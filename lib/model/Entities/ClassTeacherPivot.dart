class ClassTeacherPivot {
  final String id;
  final String schoolClass_id;
  final String teacher_id;

  ClassTeacherPivot({
    this.id,
    this.schoolClass_id,
    this.teacher_id,
  });

  factory ClassTeacherPivot.fromJson(Map<String, dynamic> json) {
    return ClassTeacherPivot(
        id: json['id'],
        schoolClass_id: json['schoolClass_id'],
        teacher_id: json['teacher_id']);
  }
}
