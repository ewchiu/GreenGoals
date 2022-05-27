import 'package:flutter/material.dart';
import 'package:greengoals/summary.dart';
import 'package:greengoals/summary_week.dart';
import 'package:greengoals/welcome_display.dart';

class WelcomeBase extends StatelessWidget {
  const WelcomeBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: 'Welcome',
        home: Scaffold(
          body: const WelcomeDisplay(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SummaryWeek(),
                ),
              );
            },
            label: const Text('Continue'),
            icon: const Icon(Icons.arrow_right_rounded),
            backgroundColor: Colors.green,
          ),
        ),
      ),
    );
  }
}
