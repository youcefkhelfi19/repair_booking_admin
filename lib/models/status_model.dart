import 'package:flutter/material.dart';

class Status {
  String title;
  IconData? icon;
  Status({required this.title,this.icon});
}
class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel({
    required this.isSelected,
    required this.buttonText,
  });
}