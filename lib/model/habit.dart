import 'dart:core';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Habit {
  final String title;
  final String description;
  final bool isYesNoTask;
  final String type;
  final String repetationType;
  final DateTime dueTime;
  final int targetValue;
  final String unit;
  final String targetType;

  Habit({
    this.title,
    this.description,
    this.isYesNoTask = true,
    this.type,
    this.repetationType,
    this.dueTime,
    this.targetValue,
    this.unit,
    this.targetType,
  });
}
