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
    this.type = ActivityTypeEnum.career,
    this.state = ActivityState.doing,
    this.doneDate,
    this.milestones,
  }) {
    if (description == null) description = '';

    if (currentValue == null) currentValue = startValue;

    if (startDate == null) startDate = DateTime.now().toUtc();

    if (targetDate == null) targetDate = DateTime.now().toUtc();

    if (doneDate == null) doneDate = DateTime.now().toUtc();

    if (milestones == null) milestones = <Milestone>[];
  }

  double getDonePercent() {
    return currentValue / targetValue;
  }

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  Map<String, dynamic> toJson() => _$GoalToJson(this);

  void completeMilestone(int index) {
    milestones[index].state = ActivityState.done;
    currentValue = currentValue + milestones[index].targetValue > targetValue
        ? targetValue
        : currentValue + milestones[index].targetValue;
    if (currentValue == targetValue) {
      state = ActivityState.done;
      doneDate = DateTime.now().toUtc();
    }
  }
}

@JsonSerializable()
class Milestone {
  String title;
  String description;
  int targetValue;
  DateTime targetDate;
  int state;

  Milestone({
    this.title,
    this.description,
    this.targetValue = 0,
    this.targetDate,
    this.state = 0,
  }) {
    if (description == null) description = '';
    if (targetDate == null) targetDate = DateTime.now().toUtc();
  }

  factory Milestone.fromJson(Map<String, dynamic> json) =>
      _$MilestoneFromJson(json);

  Map<String, dynamic> toJson() => _$MilestoneToJson(this);
}
