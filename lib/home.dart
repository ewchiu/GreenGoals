import 'package:flutter/material.dart';
import 'package:greengoals/goals_response.dart';
import 'service.dart' as service;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Goal>>(
        future: service.getGoals(),
        builder: (context, AsyncSnapshot<List<Goal>> goals) {
          if (goals.hasData) {
            return Scaffold(
              appBar: AppBar(
                  title:const Text("GreenGoals")
              ),
              body: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        leading: Icon(goals.data?[index].categoryIcon ?? Icons.list),
                        trailing: const Icon(Icons.check_box_outline_blank),
                        title: Text(goals.data?[index].description ?? "")
                    );
                  }
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
    );
  }
}
