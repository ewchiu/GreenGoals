import 'package:flutter/material.dart';
import 'package:greengoals/goals_response.dart';
import 'service.dart' as service;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Goal>>(
        future: service.getGoals(),
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
}