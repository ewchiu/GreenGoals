import 'package:flutter/material.dart';

//Creating a class to store the Goals data;
class GoalsResponse {
  int count = 0;
  List<Goal> goals = [];

  GoalsResponse(this.count, this.goals);
}

class Goal {
  String category = "";
  IconData categoryIcon = Icons.list;
  String description = "";
  int goalId = 0;
  int points = 0;

  Goal(this.category, this.categoryIcon, this.description, this.goalId, this.points);
}