import 'dart:convert';
import 'package:flutter/material.dart';
import 'line_chart.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SummaryWeek extends StatefulWidget {
  const SummaryWeek({Key? key}) : super(key: key);

  @override
  State<SummaryWeek> createState() => _SummaryWeekState();
}

class _SummaryWeekState extends State<SummaryWeek> {
  String base_url = "http://ec2-34-207-4-42.compute-1.amazonaws.com";

  List<String> _get_data_week_dates() {
    List<String> dates = [];
    for (var i = 0; i < 7; i++) {
      var now = DateTime.now().subtract(Duration(days: i));
      var formatter = DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      dates.add(formattedDate);
    }
    return dates;
  }

  Future<List<TimeSeriesSales>> _get_data_last_week(int uid) async {
    var url = Uri.parse(base_url + '/users/' + uid.toString() + '/goals');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<TimeSeriesSales> chart_items = [];
      List<String> dates = _get_data_week_dates();
      print(dates);
      for (var date in dates) {
        int count = 0;
        for (var goal in responseData['goals']) {
          if (date == goal['date_assigned'] && goal['complete']) {
            count++;
          }
        }
        chart_items.add(TimeSeriesSales(DateTime.parse(date), count));
      }

      return chart_items;
    } else {
      return [
        TimeSeriesSales(DateTime(2022, 1, 1), 0),
        TimeSeriesSales(DateTime(2022, 1, 2), 0),
        TimeSeriesSales(DateTime(2022, 1, 3), 0),
        TimeSeriesSales(DateTime(2022, 1, 4), 0),
        TimeSeriesSales(DateTime(2022, 1, 5), 0),
        TimeSeriesSales(DateTime(2022, 1, 6), 0),
        TimeSeriesSales(DateTime(2022, 1, 7), 0),
      ];
    }
  }

  Future<Map<dynamic, dynamic>> _get_data() async {
    Map<dynamic, dynamic> data = {};
    String email = FirebaseAuth.instance.currentUser!.email!;

    // Get user's point total
    var url = Uri.parse(base_url + '/users/' + email);
    var response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var responseData2 = json.decode(response.body);
      print(responseData2);
      if (responseData2['points'] != null) {
        data['points'] = responseData2['points'].toString();
        int uid = responseData2['user_id'];
        data['progress'] = await _get_data_last_week(uid);
      } else {
        data['points'] = "0";
        data['progress'] = [];
      }
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
          child: FutureBuilder(
        future: _get_data(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            String points = snapshot.data!['points'];
            children = <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: const [
                    Icon(
                      Icons.area_chart_outlined,
                      color: Colors.black,
                      size: 40,
                    ),
                    Text(
                      'Weekly Progress',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 400),
                    child: SimpleTimeSeriesChart.withData(
                        snapshot.data!['progress'])),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.score,
                      color: Colors.black,
                      size: 40,
                    ),
                    Text(
                      'Points Earned: $points',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
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
      )),
    );
  }
}
