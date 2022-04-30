import 'package:flutter/material.dart';
import 'auth_gate.dart';

//List<Goal> goals = [];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root
// of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "GreenGoalsApp",
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        home: const AuthGate());
  }
}
