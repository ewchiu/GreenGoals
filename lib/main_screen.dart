import 'package:flutter/material.dart';
import 'package:greengoals/goals_response.dart';
import 'service.dart' as service;
import 'home.dart';
import 'summary_week.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  final pages = [
    const HomePage(),
    const SummaryWeek(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GreenGoals")),
      body: pages[pageIndex],
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
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: const Icon(
                Icons.home_outlined,
                color: Colors.white,
                size: 35,
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
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
  }
}
