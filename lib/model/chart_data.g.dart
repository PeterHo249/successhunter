// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskCountPerType _$TaskCountPerTypeFromJson(Map<String, dynamic> json) {
  return TaskCountPerType(
      date: json['date'] as int, value: json['value'] as int);
}

Map<String, dynamic> _$TaskCountPerTypeToJson(TaskCountPerType instance) =>
    <String, dynamic>{'date': instance.date, 'value': instance.value};

TaskCountPerDate _$TaskCountPerDateFromJson(Map<String, dynamic> json) {
  return TaskCountPerDate(
      date: json['date'] as int,
      doingCount: json['doingCount'] as int,
      attainedCount: json['attainedCount'] as int,
      failedCount: json['failedCount'] as int);
}

Map<String, dynamic> _$TaskCountPerDateToJson(TaskCountPerDate instance) =>
    <String, dynamic>{
      'date': instance.date,
      'doingCount': instance.doingCount,
      'attainedCount': instance.attainedCount,
      'failedCount': instance.failedCount
    };
