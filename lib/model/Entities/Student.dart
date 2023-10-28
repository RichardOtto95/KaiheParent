import 'package:flutter/material.dart';

class Student {
  final String id;
  final String name;
  final String registration;
  final String schoolClass_id;
  final String password;
  final String birthday;
  String lastSeen;
  bool hasMsg;

  Student(
      {@required this.id,
      this.name,
      this.registration,
      this.schoolClass_id,
      this.password,
      this.birthday,
      this.lastSeen,
      this.hasMsg});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      registration: json['registration'],
      schoolClass_id: json['schoolClass_id'],
      password: json['password'],
      birthday: json['birthday'],
      lastSeen: json['lastSeen'],
      hasMsg: json['hasMsg'],
    );
  }
}
