import 'package:flutter/material.dart';
import 'package:successhunter/model/goal.dart';
import 'package:successhunter/style/theme.dart' as Theme;

final goals = <Goal>[
  Goal(
    title: 'First goal',
    startDate: DateTime.now(),
    endDate: DateTime.parse('20181106'),
    donePercent: 0.75,
  ),
  Goal(
    title: 'Second goal',
    startDate: DateTime.now(),
    endDate: DateTime.parse('20181206'),
    donePercent: 0.3,
  ),
];

class GoalPage extends StatefulWidget {
  @override
  GoalPageState createState() {
    return new GoalPageState();
  }
}

class GoalPageState extends State<GoalPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: Theme.Colors.primaryGradient,
      ),
      child: Center(
        child: Text('Goal'),
      ),
    );
  }
}
