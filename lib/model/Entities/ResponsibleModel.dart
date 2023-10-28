import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResponsibleModel {
  String id;
  String avatar;
  String cpf;
  String kinship;
  String name;
  String phone;

  ResponsibleModel({
    this.id,
    this.avatar,
    @required this.cpf,
    @required this.kinship,
    @required this.name,
    @required this.phone,
  });

  factory ResponsibleModel.fromDocument(DocumentSnapshot doc) {
    return ResponsibleModel(
      id: doc['id'],
      avatar: doc['avatar'],
      cpf: doc['cpf'],
      kinship: doc['kinship'],
      name: doc['name'],
      phone: doc['phone'],
    );
  }

  Map<String, dynamic> toJson(ResponsibleModel model) => {
        'id': model.id,
        'avatar': model.avatar,
        'cpf': model.cpf,
        'kinship': model.kinship,
        'name': model.name,
        'phone': model.phone,
      };
}
