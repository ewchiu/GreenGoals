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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Goal>>(
        future: getOrCreateUsersGoals(auth),
        builder: (context, AsyncSnapshot<List<Goal>> goals) {
          if (goals.hasData) {
            return ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    value: false,
                    onChanged: (bool? newValue) {
                      markGoal(newValue, index);
                    },
                    title: Text(goals.data?[index].description ?? ""),
                    secondary: Container(
                      height: 25,
                      width: 25,
                      child: Icon(goals.data?[index].categoryIcon ?? Icons.list),
                    ),
                  );
                }
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
    );
  }

  void markGoal(bool? newValue, int index) {
    setState(() {
      //checkBoxListTileModel[index].isCheck = val;
    });
  }

  Future<int> getUserId(String email) async {
    UserResponse usrResponse = await service.getUser(email);
    return usrResponse.userId;
  }

  Future<String?> getUserEmail(FirebaseAuth auth) async {
    return await auth.currentUser?.email;
  }

  Future<List<Goal>> getOrCreateUsersGoals(FirebaseAuth auth) async {
    List<Goal> currGoals = [];
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
        currGoals.add(currGoal);
      }
    }

    return currGoals;
  }
}