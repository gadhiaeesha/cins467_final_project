import 'package:app_practice/Models/chore.dart';
import 'package:flutter/material.dart';

class Members {
  int id;
  String name;
  List<Chores> chores;

  Members({
    required this.id,
    required this.name,
    required this.chores,
  });
}