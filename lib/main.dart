import 'package:flutter/material.dart';
import 'package:greengoals/goals_response.dart';
import 'service.dart' as service;

Future<void> main() async => runApp(const MyApp());

//List<Goal> goals = [];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root
// of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "GreenGoalsApp",
        theme: ThemeData(
            primarySwatch: Colors.green
        ),
        debugShowCheckedModeBanner: false,
        home: const ListViewBuilder()
    );
  }
}
class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({Key? key}) : super(key: key);

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
                  itemCount: goals.data?.length ?? 0,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                        leading: const Icon(Icons.list),
                        trailing: const Icon(Icons.check_box_outline_blank),
                        title:Text(goals.data?[index].description ?? "")
                    );
                  }
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
    );

    /*
    goals = await service.getGoals();

    return Scaffold(
      appBar: AppBar(
          title:const Text("GreenGoals")
      ),
      body: ListView.builder(
          itemCount: goals.length,
          itemBuilder: (BuildContext context, int index){
            return ListTile(
                leading: const Icon(Icons.list),
                trailing: const Icon(Icons.check_box_outline_blank),
                title:Text(goals[index].description)
            );
          }
      ),
    );
    */
  }
}