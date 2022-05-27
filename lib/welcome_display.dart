import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:http/http.dart' as http;

class WelcomeDisplay extends StatefulWidget {
  const WelcomeDisplay({Key? key}) : super(key: key);

  @override
  State<WelcomeDisplay> createState() => _WelcomeDisplayState();
}

class _WelcomeDisplayState extends State<WelcomeDisplay> {
  Future<String> _get_email() async {
    String base_url = "http://ec2-34-207-4-42.compute-1.amazonaws.com";
    String email = FirebaseAuth.instance.currentUser!.email!;
    // String email = "test@oregonstate.edu";
    var url = Uri.parse(base_url + '/users');
    var user_url = Uri.parse(base_url + '/users/' + email);
    String data = "\nWelcome!\n";
    data += "\nLogged in as: " + email;

    try {
      var response = await http.get(user_url);
      if (response.statusCode != 200) {
        var response2 = await http.post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'email': email,
            }));
      }
    } catch (e) {
      print(e);
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: _get_email(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('${snapshot.data}',
                    style: const TextStyle(fontSize: 15)),
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
