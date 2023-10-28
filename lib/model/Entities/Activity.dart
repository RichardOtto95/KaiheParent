import 'package:flutter/material.dart';

class Activity {
  final String time;
  final String id;
  final String date;
  final String description;
  final String type;
  final String name;
  final String message;
  final bool haveImage;
  final evaluation_id = null;
  final bool isApproved;
  final String schoolClass;
  final String activityDate;
  final bool needAuth;

  Activity(
      {@required this.time,
      this.id,
      this.date,
      this.description,
      this.type,
      this.message,
      this.name,
      this.haveImage,
      this.schoolClass,
      this.isApproved,
      this.activityDate,
      this.needAuth});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
        id: json['id'],
        time: json['time'],
        date: json['date'],
        type: json['type'],
        name: json['name'],
        message: json['message'],
        description: json['description'],
        schoolClass: json['schoolClass'],
        isApproved: json['isApproved'],
        activityDate: json['activityDate'],
        needAuth: json['needAuth'],
        haveImage: json['haveImage']);
  }
}
