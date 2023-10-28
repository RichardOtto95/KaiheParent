import 'package:flutter/material.dart';

class MedicalRecord {
  final String id;
  final String allergy;
  final String remedy;
  final String bloodType;
  final bool authorization;
  final String hospitalName;
  final String studentID;
  final bool havePrescription;

  MedicalRecord(
      {this.id,
      this.remedy,
      this.allergy,
      this.hospitalName,
      @required this.studentID,
      @required this.bloodType,
      @required this.authorization,
      this.havePrescription});

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'],
      remedy: json['remedy'],
      allergy: json['allergy'],
      hospitalName: json['hospitalName'],
      studentID: json['studentID'],
      bloodType: json['bloodType'],
      authorization: json['authorization'],
      havePrescription: json['havePrescription'],
    );
  }
}
