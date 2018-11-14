import 'dart:core';
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
  String unit;
  String type;
  String repetationType;
  int period;
  List<String> daysOfWeek;
  int state;
  List<List<DateTime>> streak;

  Habit({
    this.title,
    this.description = '',
    this.dueTime,
    this.isYesNoTask = true,
    this.targetValue,
    this.unit,
    this.type = ActivityTypeEnum.career,
    this.repetationType = RepetationTypeEnum.everyDay,
    this.period,
    this.daysOfWeek,
    this.state = ActivityState.doing,
    this.streak,
  }) {
    if (dueTime == null) dueTime = DateTime(2018, 1, 1, 21);
    if (!isYesNoTask) {
      if (targetValue == null) targetValue = 100;
      if (unit == null) unit = '%';
    }
    if (streak == null) streak = <List<DateTime>>[];
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
  }

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

  Map<String, dynamic> toJson() => _$HabitToJson(this);
}
