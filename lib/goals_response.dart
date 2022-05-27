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

class UserGoalsResponse {
  int count = 0;
  List<UserGoal> userGoals = [];

  UserGoalsResponse(this.count, this.userGoals);
}

class UserGoal {
  int id = 0;
  int userId = 0;
  int goalId = 0;
  String dateAssigned = "";
  bool complete = false;

  UserGoal(this.id, this.userId, this.goalId, this.dateAssigned, this.complete);
}