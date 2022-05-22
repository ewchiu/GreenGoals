import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'goals_response.dart';
import 'package:flutter/material.dart';

String baseUrl = 'http://ec2-34-207-4-42.compute-1.amazonaws.com/';

Future<List<Goal>> getGoals() async {
  var url = Uri.parse(baseUrl + 'goals');
  List<Goal> goalsList = [];

  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
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
