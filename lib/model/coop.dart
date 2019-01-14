import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:successhunter/utils/enum_dictionary.dart';

part 'coop.g.dart';

@JsonSerializable()
class CoopGoal {
  String title;
  String description;
  DateTime startDate;
  DateTime targetDate;
  int startValue;
  int currentValue;
  int targetValue;
  String unit;
  String type;
  DateTime doneDate;
  List<CoopMilestone> milestones;
  String ownerUid;
  List<String> participantUids;
  List<ParticipantState> states;
  int mainState;

  CoopGoal({
    this.title,
    this.description,
    this.startDate,
    this.targetDate,
    this.startValue = 0,
    this.currentValue,
    this.targetValue = 100,
    this.unit = '%',
    this.type = ActivityTypeEnum.career,
    this.states,
    this.doneDate,
    this.milestones,
    this.mainState = 0,
  }) {
    if (description == null) description = '';

    if (currentValue == null) currentValue = startValue;

    if (startDate == null) startDate = DateTime.now().toUtc();

    if (targetDate == null) targetDate = DateTime.now().toUtc();

    if (doneDate == null) doneDate = DateTime.now().toUtc();

    if (ownerUid == null) ownerUid = gInfo.uid;

    if (participantUids == null) participantUids = [ownerUid];

    if (states == null)
      states = [ParticipantState(uid: ownerUid, state: ActivityState.doing)];
  }

  factory CoopGoal.fromJson(Map<String, dynamic> json) =>
      _$CoopGoalFromJson(json);

  Map<String, dynamic> toJson() => _$CoopGoalToJson(this);
}

@JsonSerializable()
class CoopMilestone {
  String title;
  String description;
  int targetValue;
  DateTime targetDate;
  List<ParticipantState> states;

  CoopMilestone({
    this.title,
    this.description,
    this.targetDate,
    this.targetValue = 0,
    this.states,
  }) {
    if (description == null) description = '';
    if (targetDate == null) targetDate = DateTime.now().toUtc();
    if (states == null)
      states = [ParticipantState(uid: gInfo.uid, state: ActivityState.doing)];
  }

  factory CoopMilestone.fromJson(Map<String, dynamic> json) =>
      _$CoopMilestoneFromJson(json);

  Map<String, dynamic> toJson() => _$CoopMilestoneToJson(this);
}

@JsonSerializable()
class ParticipantState {
  String uid;
  int state;

  ParticipantState({
    @required this.uid,
    this.state = ActivityState.doing,
  });

  factory ParticipantState.fromJson(Map<String, dynamic> json) =>
      _$ParticipantStateFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantStateToJson(this);
}
