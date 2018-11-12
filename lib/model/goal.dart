import 'dart:core';
import 'package:flutter/material.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:json_annotation/json_annotation.dart';

part 'goal.g.dart';

@JsonSerializable()

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
  int state;
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
    this.state = ActivityState.doing,
    this.doneDate,
    this.milestones,
  }) {
    if (description == null) description = '';

    if (currentValue == null) currentValue = startValue;

    if (startDate == null) startDate = DateTime.now();

    if (targetDate == null) targetDate = DateTime.now();

    if (doneDate == null) doneDate = DateTime.now();

    if (milestones == null) milestones = <Milestone>[];
  }

  double getDonePercent() {
    return currentValue / targetValue;
  }

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  Map<String, dynamic> toJson() => _$GoalToJson(this);

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
@JsonSerializable()
class Milestone {
  String title;
  String description;
  int targetValue;
  DateTime targetDate;
  bool isDone;

  Milestone({
    this.title,
    this.description,
    this.targetValue = 0,
    this.targetDate,
    this.isDone = false,
  }) {
    if (description == null) description = '';
    if (targetDate == null) targetDate = DateTime.now();
  }

  factory Milestone.fromJson(Map<String, dynamic> json) => _$MilestoneFromJson(json);

  Map<String, dynamic> toJson() => _$MilestoneToJson(this);
}
