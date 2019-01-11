// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoopGoal _$CoopGoalFromJson(Map<String, dynamic> json) {
  return CoopGoal(
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
      states: (json['states'] as List)
          ?.map((e) => e == null
              ? null
              : ParticipantState.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      doneDate: json['doneDate'] == null
          ? null
          : DateTime.parse(json['doneDate'] as String),
      milestones: (json['milestones'] as List)
          ?.map((e) => e == null
              ? null
              : CoopMilestone.fromJson(e as Map<String, dynamic>))
          ?.toList())
    ..ownerUid = json['ownerUid'] as String
    ..participantUids =
        (json['participantUids'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$CoopGoalToJson(CoopGoal instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'startDate': instance.startDate?.toIso8601String(),
      'targetDate': instance.targetDate?.toIso8601String(),
      'startValue': instance.startValue,
      'currentValue': instance.currentValue,
      'targetValue': instance.targetValue,
      'unit': instance.unit,
      'type': instance.type,
      'doneDate': instance.doneDate?.toIso8601String(),
      'milestones': instance.milestones,
      'ownerUid': instance.ownerUid,
      'participantUids': instance.participantUids,
      'states': instance.states
    };

CoopMilestone _$CoopMilestoneFromJson(Map<String, dynamic> json) {
  return CoopMilestone(
      title: json['title'] as String,
      description: json['description'] as String,
      targetDate: json['targetDate'] == null
          ? null
          : DateTime.parse(json['targetDate'] as String),
      targetValue: json['targetValue'] as int,
      states: (json['states'] as List)
          ?.map((e) => e == null
              ? null
              : ParticipantState.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$CoopMilestoneToJson(CoopMilestone instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'targetValue': instance.targetValue,
      'targetDate': instance.targetDate?.toIso8601String(),
      'states': instance.states
    };

ParticipantState _$ParticipantStateFromJson(Map<String, dynamic> json) {
  return ParticipantState(
      uid: json['uid'] as String, state: json['state'] as int);
}

Map<String, dynamic> _$ParticipantStateToJson(ParticipantState instance) =>
    <String, dynamic>{'uid': instance.uid, 'state': instance.state};
