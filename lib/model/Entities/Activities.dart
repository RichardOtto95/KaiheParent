import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Activities {
  final String id;
  final String activity;
  final Timestamp created_at;
  final String class_id;
  final String note;
  final String option;
  final bool sanitized;
  final String student_id;
  final String teacher_id;
  final String title;
  final String what;
  final String how;
  final String attendence;
  final String description;
  final List<dynamic> images;

  Activities(
      {@required this.id,
      this.activity,
      this.created_at,
      this.class_id,
      this.note,
      this.attendence,
      this.option,
      this.sanitized,
      this.student_id,
      this.teacher_id,
      this.title,
      this.what,
      this.how,
      this.description,
      this.images});

  factory Activities.fromJson(Map<String, dynamic> json) {
    return Activities(
        id: json['id'],
        activity: json['activity'],
        created_at: json['created_at'],
        note: json['note'],
        option: json['option'],
        sanitized: json['sanitized'],
        student_id: json['student_id'],
        teacher_id: json['teacher_id'],
        title: json['title'],
        what: json['what'],
        how: json['how'],
        images: json['images'],
        description: json['description'],
        attendence: json["attendence"]);
  }
}
