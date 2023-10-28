import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Students {
  final String id;
  String username;
  final String register;
  String hospital;
  String prescription_drug;
  Timestamp last_view;
  List<dynamic> doctors_prescription;
  String class_id;
  String blood_type;
  Timestamp birthday;
  String avatar;
  String authorized_take_hospital;
  String allergy;
  Students(
      {@required this.id,
      this.username,
      this.register,
      this.hospital,
      this.prescription_drug,
      this.last_view,
      this.doctors_prescription,
      this.class_id,
      this.blood_type,
      this.birthday,
      this.avatar,
      this.authorized_take_hospital,
      this.allergy});

  factory Students.fromJson(Map<String, dynamic> json) {
    return Students(
        id: json['id'],
        username: json['username'],
        register: json['register'],
        hospital: json['hospital'],
        prescription_drug: json['prescription_drug'],
        last_view: json['last_view'],
        doctors_prescription: json['doctors_prescription'],
        class_id: json['class_id'],
        blood_type: json['blood_type'],
        birthday: json['birthday'],
        avatar: json['avatar'],
        authorized_take_hospital: json['authorized_take_hospital'],
        allergy: json['allergy']);
  }

  factory Students.fromDocument(DocumentSnapshot doc) {
    return Students(
      id: doc['id'],
      avatar: doc['avatar'],
      username: doc['username'],
      register: doc['register'],
      hospital: doc['hospital'],
      prescription_drug: doc['prescription_drug'],
      last_view: doc['last_view'],
      doctors_prescription: doc['doctors_prescription'],
      class_id: doc['class_id'],
      blood_type: doc['blood_type'],
      birthday: doc['birthday'],
      authorized_take_hospital: doc['authorized_take_hospital'],
      allergy: doc['allergy'],
    );
  }

  Map<String, dynamic> toJson(Students model) => {
        'id': model.id,
        'avatar': model.avatar,
        'username': model.username,
        'register': model.register,
        'hospital': model.hospital,
        'prescription_drug': model.prescription_drug,
        'last_view': model.last_view,
        'doctors_prescription': model.doctors_prescription,
        'class_id': model.class_id,
        'blood_type': model.blood_type,
        'birthday': model.birthday,
        'authorized_take_hospital': model.authorized_take_hospital,
        'allergy': model.allergy
      };
}
