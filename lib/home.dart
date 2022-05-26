import 'package:flutter/material.dart';
import 'package:greengoals/goals_response.dart';
import 'service.dart' as service;
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;

  final pages = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

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
              bottomNavigationBar: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
    );
  }
}
