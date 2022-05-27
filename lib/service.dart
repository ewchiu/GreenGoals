import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'goals_response.dart';
import 'user_response.dart';
import 'package:flutter/material.dart';

String baseUrl = 'http://ec2-34-207-4-42.compute-1.amazonaws.com/';

Future<List<Goal>> getGoals() async {
  var url = Uri.parse(baseUrl + 'goals');
  List<Goal> goalsList = [];

  try {
    var response = await http.get(url);

    if (response.statusCode < 300) {
      var responseData = json.decode(response.body);
      var count = responseData["count"] as int;
      var rawGoals = responseData["goals"];

      for (var goal in rawGoals) {
        print(goal);

        Goal currGoal = Goal(
            goal["category"],
            getIcon(goal["category"]),
            goal["description"],
            goal["goal_id"],
            goal["points"]
        );

        goalsList.add(currGoal);
      }
    }
  } catch (e) {
    print(e);
  }

  goalsList.shuffle();
  return goalsList;
}

IconData getIcon(String category) {
  if (category == "Carbon Footprint") {
    return Icons.directions_bus_sharp;
  } else if (category == "Solid Waste") {
    return Icons.restore_from_trash_outlined;
  } else if (category == "Water") {
    return Icons.water_drop;
  } else {
    return Icons.list;
  }
}

Future<UserResponse> getUser(String email) async {
  var url = Uri.parse(baseUrl + 'users/' + email);
  UserResponse usr = UserResponse(0, "", 0);

  try {
    var response = await http.get(url);

    if (response.statusCode < 300) {
      var responseData = json.decode(response.body);

      usr = UserResponse(
          responseData["user_id"],
          responseData["email"],
          responseData["points"]
      );
    }
  } catch (e) {
    print(e);
  }

  return usr;
}

Future<UserGoalsResponse> getUsersGoals(int userId) async {
  var url = Uri.parse(baseUrl + 'users/' + userId.toString() + '/goals');
  List<UserGoal> goalsList = [];
  UserGoalsResponse userGoals = UserGoalsResponse(0, goalsList);

  try {
    var response = await http.get(url);

    if (response.statusCode < 300) {
      var responseData = json.decode(response.body);
      var count = responseData["count"] as int;
      var rawGoals = responseData["goals"];

      for (var goal in rawGoals) {
        print(goal);

        UserGoal currGoal = UserGoal(
            goal["id"],
            goal["user_id"],
            goal["goal_id"],
            goal["date_assigned"],
            goal["complete"]
        );

        goalsList.add(currGoal);
      }

      userGoals = UserGoalsResponse(
        count,
        goalsList
      );
    }
  } catch (e) {
    print(e);
  }

  return userGoals;
}

Future<bool> createUsersGoal(int userId, int goalId) async {
  var url = Uri.parse(baseUrl + 'users/' + userId.toString() + '/goals');
  bool isSuccess = false;

  try {
    var response = await http.post(
        url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'goal_id': goalId.toString()
      }),
    );

    if (response.statusCode < 300) {
      print("createUsersGoal success");
      isSuccess = true;
    } else {
      print("createUsersGoal error");
    }
  } catch (e) {
    print(e);
  }

  return isSuccess;
}

Future<Goal> getGoal(int goalId) async {
  var url = Uri.parse(baseUrl + 'goals/' + goalId.toString());
  Goal gl = Goal("", Icons.list, "", 0, 0);

  try {
    var response = await http.get(url);

    if (response.statusCode < 300) {
      var responseData = json.decode(response.body);

      gl = Goal(
          responseData["category"],
          getIcon(responseData["category"]),
          responseData["description"],
          responseData["goal_id"],
          responseData["points"]
      );
    }
  } catch (e) {
    print(e);
  }

  return gl;
}

Future<bool> updateUsersGoal(int userId, int userGoalId) async {
  var url = Uri.parse(baseUrl + 'users/' + userId.toString() + '/goals/' + userGoalId.toString());
  bool isSuccess = false;

  try {
    var response = await http.patch(url);

    if (response.statusCode < 300) {
      print("updateUsersGoal success, response.statusCode= ${response.statusCode}");
      isSuccess = true;
    } else {
      print("updateUsersGoal error, response.statusCode= ${response.statusCode}, userGoalId = $userGoalId");
    }
  } catch (e) {
    print(e);
  }

  return isSuccess;
}

Future<UserResponse> addPoints(String email, int points) async {
  var url = Uri.parse(baseUrl + 'users/' + email);
  UserResponse updatedUsr = UserResponse(0, "", 0);

  try {
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'points': points
      }),
    );

    if (response.statusCode < 300) {
      print("addPoints success");
      var responseData = json.decode(response.body);

      updatedUsr = UserResponse(
          responseData["user_id"],
          responseData["email"],
          responseData["points"],
      );
    } else {
      print("addPoints error, response.statusCode= ${response.statusCode}, email = $email, points = $points");
    }
  } catch (e) {
    print(e);
  }

  return updatedUsr;
}
