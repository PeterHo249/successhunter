// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Habit _$HabitFromJson(Map<String, dynamic> json) {
  return Habit(
      title: json['title'] as String,
      description: json['description'] as String,
      dueTime: json['dueTime'] == null
          ? null
          : DateTime.parse(json['dueTime'] as String),
      isYesNoTask: json['isYesNoTask'] as bool,
      targetValue: json['targetValue'] as int,
      currentValue: json['currentValue'] as int,
      unit: json['unit'] as String,
      type: json['type'] as String,
      repetationType: json['repetationType'] as String,
      period: json['period'] as int,
      daysOfWeek:
          (json['daysOfWeek'] as List)?.map((e) => e as String)?.toList(),
      state: json['state'] as int,
      streak: (json['streak'] as List)
          ?.map((e) => e == null ? null : DateTime.parse(e as String))
          ?.toList(),
      isInStreak: json['isInStreak'] as bool,
      currentDate: json['currentDate'] == null
          ? null
          : DateTime.parse(json['currentDate'] as String),
      longestStreak: json['longestStreak'] as int,
      currentStreak: json['currentStreak'] as int);
}

Map<String, dynamic> _$HabitToJson(Habit instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'dueTime': instance.dueTime?.toIso8601String(),
      'isYesNoTask': instance.isYesNoTask,
      'targetValue': instance.targetValue,
      'currentValue': instance.currentValue,
      'unit': instance.unit,
      'type': instance.type,
      'repetationType': instance.repetationType,
      'period': instance.period,
      'daysOfWeek': instance.daysOfWeek,
      'state': instance.state,
      'streak': instance.streak?.map((e) => e?.toIso8601String())?.toList(),
      'isInStreak': instance.isInStreak,
      'currentDate': instance.currentDate?.toIso8601String(),
      'longestStreak': instance.longestStreak,
      'currentStreak': instance.currentStreak
    };
