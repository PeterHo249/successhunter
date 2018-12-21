import 'package:json_annotation/json_annotation.dart';

part 'chart_data.g.dart';

@JsonSerializable()
class TaskCountPerType {
  final int date;
  final int value;

  TaskCountPerType({
    this.date,
    this.value: 0,
  });

  factory TaskCountPerType.fromJson(Map<String, dynamic> json) => _$TaskCountPerTypeFromJson(json);

  Map<String, dynamic> toJson() => _$TaskCountPerTypeToJson(this);
}

@JsonSerializable()
class TaskCountPerDate {
  final int date;
  final int doingCount;
  final int attainedCount;
  final int failedCount;

  TaskCountPerDate({
    this.date,
    this.doingCount: 0,
    this.attainedCount: 0,
    this.failedCount: 0,
  });

  factory TaskCountPerDate.fromJson(Map<String, dynamic> json) => _$TaskCountPerDateFromJson(json);

  Map<String, dynamic> toJson() => _$TaskCountPerDateToJson(this);
}