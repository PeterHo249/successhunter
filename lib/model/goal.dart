import 'dart:core';

class Goal {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime targetDate;
  final int startValue;
  final int targetValue;
  final String unit;
  final String type;
  final double donePercent;

  Goal({
    this.title,
    this.description,
    this.startDate,
    this.targetDate,
    this.donePercent,
    this.startValue,
    this.targetValue,
    this.unit,
    this.type,
  });
}
