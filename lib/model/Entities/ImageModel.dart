import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageModel {
  final String id;
  final String data;

  ImageModel({this.id, this.data});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(id: json['id']);
  }
}
