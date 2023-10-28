import 'package:flutter/material.dart';

class GuardianPivot {
  final String id;
  final String student_id;
  final String guardian_id;

  GuardianPivot({
    this.id,
    this.student_id,
    this.guardian_id,
  });

  factory GuardianPivot.fromJson(Map<String, dynamic> json) {
    return GuardianPivot(
        id: json['id'],
        student_id: json['student_id'],
        guardian_id: json['guardian_id']);
  }
}
