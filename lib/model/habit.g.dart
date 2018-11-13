// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Habit _$HabitFromJson(Map<String, dynamic> json) {
  return Habit(
      title: json['title'] as String,
      description: json['description'] as String,
      isYesNoTask: json['isYesNoTask'] as bool,
      type: json['type'] as String,
      repetationType: json['repetationType'] as String,
      dueTime: json['dueTime'] == null
          ? null
          : DateTime.parse(json['dueTime'] as String),
      targetValue: json['targetValue'] as int,
      unit: json['unit'] as String,
      targetType: json['targetType'] as String);
}

Map<String, dynamic> _$HabitToJson(Habit instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'isYesNoTask': instance.isYesNoTask,
      'type': instance.type,
      'repetationType': instance.repetationType,
      'dueTime': instance.dueTime?.toIso8601String(),
      'targetValue': instance.targetValue,
      'unit': instance.unit,
      'targetType': instance.targetType
    };
