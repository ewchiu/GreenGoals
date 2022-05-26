import 'package:flutter/material.dart';
import 'package:greengoals/goals_response.dart';
import 'service.dart' as service;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Goal>>(
        future: service.getGoals(),
        builder: (context, AsyncSnapshot<List<Goal>> goals) {
          if (goals.hasData) {
            return ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      leading: Icon(goals.data?[index].categoryIcon ?? Icons.list),
                      trailing: const Icon(Icons.check_box_outline_blank),
                      title: Text(goals.data?[index].description ?? "")
                  );
                }
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
    );
  }
}