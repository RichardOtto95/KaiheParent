import 'package:flutter/material.dart';

class Guardian {
  final String id;
  final String name;
  final String phoneNumber;
  final String kinship;

  Guardian({this.id, this.name, this.phoneNumber, this.kinship});

  factory Guardian.fromJson(Map<String, dynamic> json) {
    return Guardian(
        id: json['id'],
        name: json['name'],
        kinship: json['kinship'],
        phoneNumber: json['phoneNumber']);
  }
}
