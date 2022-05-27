import 'package:flutter/material.dart';
import 'package:greengoals/line_chart.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      child: Column(children: [
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
              constraints: const BoxConstraints(maxHeight: 400),
              child: SimpleTimeSeriesChart.withSampleData()),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: const [
              Icon(
                Icons.score,
                color: Colors.black,
                size: 40,
              ),
              Text(
                'Points Earned: 220',
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ]),
    ));
  }
}
