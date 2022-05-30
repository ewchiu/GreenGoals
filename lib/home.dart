import 'package:flutter/material.dart';
import 'package:greengoals/goals_response.dart';
import 'package:greengoals/user_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'service.dart' as service;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int userId = 0;
  String userEmail = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<dynamic>>>(
        future: getOrCreateUsersGoals(auth),
        builder: (context, AsyncSnapshot<List<List<dynamic>>> goals) {
          if (goals.hasData) {
            return ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    value: goals.data?[index][1].complete ?? false,
                    onChanged: (bool? newValue) {
                      //markGoal(goals.data?[index][1].id ?? -1, goals.data?[index][0].points ?? 0);
                      maybeMarkGoalCompleted(goals.data?[index][0], goals.data?[index][1]);
                    },
                    title: Text(goals.data?[index][0].description ?? ""),
                    secondary: Container(
                      height: 25,
                      width: 25,
                      child: Icon(goals.data?[index][0].categoryIcon ?? Icons.list),
                    ),
                  );
                }
            );
          } else {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                  ],
                )
            );

            //return const CircularProgressIndicator();
          }
        }
    );
  }

  void maybeMarkGoalCompleted(Goal? goal, UserGoal? usrGoal) {
    if (goal != null && usrGoal != null && usrGoal.id != -1 && !usrGoal.complete) {
      setState(() {
        service.updateUsersGoal(userId, usrGoal.id);
        service.addPoints(userEmail, goal.points);
      });
    }
  }

  Future<int> getUserId(String email) async {
    userEmail = email;
    UserResponse usrResponse = await service.getUser(email);
    userId = usrResponse.userId;
    return userId;
  }

  Future<String?> getUserEmail(FirebaseAuth auth) async {
    return await auth.currentUser?.email;
  }

  Future<List<List<dynamic>>> getOrCreateUsersGoals(FirebaseAuth auth) async {
    List<List<dynamic>> currGoals = [];
    String? email = await getUserEmail(auth);
    print("Email address is: $email");

    if (email != null) {
      int userId = await getUserId(email);
      UserGoalsResponse currUserGoals = await service.getUsersGoals(userId);

      if (currUserGoals.count == 0) {
        // Get random 5 goals
        List<Goal> allGoals = await service.getGoals();

        // createUsersGoal loop with the id's
        for (int i = 0; i < 5; i++) {
          await service.createUsersGoal(userId, allGoals[i].goalId);
        }

        // Repull getUsersGoals and return
        currUserGoals = await service.getUsersGoals(userId);
      }

      // Map UserGoals list to Goal list
      for (var usrGoal in currUserGoals.userGoals) {
        Goal currGoal = await service.getGoal(usrGoal.goalId);
        currGoals.add([currGoal, usrGoal]);
      }
    }

    return currGoals;
  }
}