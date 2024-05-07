import 'package:app_practice/Models/member.dart';
import 'package:flutter/material.dart';

class Household {
  int id;
  String name;
  List<Members> members;
  //could also add location here

  Household({
    required this.id,
    required this.name,
    required this.members,
  });
}