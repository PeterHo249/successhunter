import 'package:flutter/material.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:successhunter/model/habit.dart';
import 'package:successhunter/model/data_feeder.dart';

class HabitPage extends StatelessWidget {
  /// Variable

  /// Business process

  /// Build layout
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: Theme.Colors.primaryGradient,
      ),
      child: Center(
        child: Text('Habit'),
      ),
    );
  }
}
