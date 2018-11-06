import 'dart:core';
import 'package:flutter/material.dart';
import 'package:successhunter/utils/enum_dictionary.dart';

class Goal {
  String title;
  String description;
  DateTime startDate;
  DateTime targetDate;
  int startValue;
  int currentValue;
  int targetValue;
  String unit;
  String type;
  bool isDone;
  DateTime doneDate;
  List<Milestone> milestones;

  Goal({
    this.title,
    this.description,
    this.startDate,
    this.targetDate,
    this.startValue = 0,
    this.currentValue,
    this.targetValue = 100,
    this.unit = '%',
    this.type = GoalTypeEnum.career,
    this.isDone = false,
    this.doneDate,
    this.milestones,
  }) {
    if (currentValue == null) currentValue = startValue;

    if (startDate == null) startDate = DateTime.now();

    if (targetDate == null) targetDate = DateTime.now();
  }

  double getDonePercent() {
    return currentValue / targetValue;
  }

  Widget buildCircularIcon() {
    var data = TypeDecorationEnum.typeDecorations[GoalTypeEnum.getIndex(type)];
    return Container(
      height: 80.0,
      width: 80.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: data.backgroundColor,
      ),
      child: Icon(
        data.icon,
        color: data.color,
        size: 30.0,
      ),
    );
  }
}

class Milestone {
  String title;
  String description;
  int targetValue;
  DateTime targetDate;
  bool isDone;

  Milestone({this.title, this.description, this.targetValue, this.targetDate, this.isDone});
}
