import 'package:flutter/material.dart';

class Teacher {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String password;
  final bool isAdmin;

  Teacher(
      {@required this.id,
      this.name,
      this.email,
      this.phoneNumber,
      this.password,
      this.isAdmin});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
        id: json['id'],
        name: json['name'],
        phoneNumber: json['registration'],
        email: json['schoolClass_id'],
        password: json['password'],
        isAdmin: json['isAdmin']);
  }
}
