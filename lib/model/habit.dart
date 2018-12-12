import 'dart:core';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:successhunter/utils/enum_dictionary.dart';

part 'habit.g.dart';

@JsonSerializable()
class Habit {
  String title;
  String description;
  DateTime dueTime;
  bool isYesNoTask;
  int targetValue;
  int currentValue;
  String unit;
  String type;
  String repetationType;
  int period;
  List<String> daysOfWeek;
  int state;
  List<DateTime> streak;
  bool isInStreak;
  DateTime currentDate;
  int longestStreak;
  int currentStreak;

  Habit({
    this.title,
    this.description = '',
    this.dueTime,
    this.isYesNoTask = true,
    this.targetValue,
    this.currentValue = 0,
    this.unit,
    this.type = ActivityTypeEnum.career,
    this.repetationType = RepetationTypeEnum.everyDay,
    this.period,
    this.daysOfWeek,
    this.state = ActivityState.doing,
    this.streak,
    this.isInStreak = false,
    this.currentDate,
    this.longestStreak = 0,
    this.currentStreak = 0,
  }) {
    if (dueTime == null) dueTime = DateTime(2018, 1, 1, 21).toUtc();
    if (!isYesNoTask) {
      if (targetValue == null) targetValue = 100;
      if (unit == null) unit = '%';
    }
    if (streak == null) streak = <DateTime>[];
    if (repetationType == RepetationTypeEnum.period) {
      if (period == null) {
        period = 1;
      }
    }
    if (repetationType == RepetationTypeEnum.dayOfWeek) {
      if (daysOfWeek == null) {
        daysOfWeek = DayOfWeekEnum.days.toList();
      }
    }
    if (currentDate == null) currentDate = DateTime.now().toUtc();
  }

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

  Map<String, dynamic> toJson() => _$HabitToJson(this);

  Widget buildCircularIcon() {
    var data = TypeDecorationEnum.typeDecorations[ActivityTypeEnum.getIndex(type)];
    return Container(
      height: 50.0,
      width: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: data.backgroundColor,
      ),
      child: Icon(
        data.icon,
        color: data.color,
        size: 15.0,
      ),
    );
  }

  void completeToday() {
    state = ActivityState.done;
    if (isInStreak) {
      streak.add(DateTime.now().toUtc());
    } else {
      streak.add(DateTime.now().toUtc());
      isInStreak = true;
    }
  }
}

class HabitDocument {
  final Habit item;
  final String documentId;

  HabitDocument({@required this.item, this.documentId,});
}