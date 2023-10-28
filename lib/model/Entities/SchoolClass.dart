import 'package:flutter/material.dart';

class SchoolClass {
  final String id;
  final String grade;
  final String password;
  final Object school_id;

  SchoolClass({this.id, this.grade, this.password, this.school_id});

  factory SchoolClass.fromJson(Map<dynamic, dynamic> json) {
    return SchoolClass(
      id: json['id'],
      grade: json['grade'],
      password: json['password'],
      school_id: json['school_id'],
    );
  }
}
