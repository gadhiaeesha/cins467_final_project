import 'package:flutter/material.dart';

class Chores {
  int id;
  String title;
  String desc;
  bool isDone;
  String date; 

  Chores({
    required this.id,
    required this.title,
    required this.desc,
    required this.isDone,
    required this.date,
  });
}