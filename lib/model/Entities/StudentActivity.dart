import 'package:flutter/material.dart';

class StudentActivity {
  final String id;
  final String student_id;
  final String activity_id;
  final bool isAuthorized;
  final bool willGo;
  final bool needSignature;

  StudentActivity(
      {@required this.id,
      this.student_id,
      this.activity_id,
      this.isAuthorized,
      this.willGo,
      this.needSignature});

  factory StudentActivity.fromJson(Map<String, dynamic> json) {
    return StudentActivity(
        id: json['id'],
        student_id: json['student_id'],
        activity_id: json['activity_id'],
        isAuthorized: json['isAuthorized'],
        willGo: json['willGo'],
        needSignature: json['needSignature']);
  }
}
