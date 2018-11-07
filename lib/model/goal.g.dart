// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Goal _$GoalFromJson(Map<String, dynamic> json) {
  return Goal(
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      targetDate: json['targetDate'] == null
          ? null
          : DateTime.parse(json['targetDate'] as String),
      startValue: json['startValue'] as int,
      currentValue: json['currentValue'] as int,
      targetValue: json['targetValue'] as int,
      unit: json['unit'] as String,
      type: json['type'] as String,
      isDone: json['isDone'] as bool,
      doneDate: json['doneDate'] == null
          ? null
          : DateTime.parse(json['doneDate'] as String),
      milestones: (json['milestones'] as List)
          ?.map((e) =>
              e == null ? null : Milestone.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$GoalToJson(Goal instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'startDate': instance.startDate?.toIso8601String(),
      'targetDate': instance.targetDate?.toIso8601String(),
      'startValue': instance.startValue,
      'currentValue': instance.currentValue,
      'targetValue': instance.targetValue,
      'unit': instance.unit,
      'type': instance.type,
      'isDone': instance.isDone,
      'doneDate': instance.doneDate?.toIso8601String(),
      'milestones': instance.milestones
    };

Milestone _$MilestoneFromJson(Map<String, dynamic> json) {
  return Milestone(
      title: json['title'] as String,
      description: json['description'] as String,
      targetValue: json['targetValue'] as int,
      targetDate: json['targetDate'] == null
          ? null
          : DateTime.parse(json['targetDate'] as String),
      isDone: json['isDone'] as bool);
}

Map<String, dynamic> _$MilestoneToJson(Milestone instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'targetValue': instance.targetValue,
      'targetDate': instance.targetDate?.toIso8601String(),
      'isDone': instance.isDone
    };
