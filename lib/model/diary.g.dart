// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Diary _$DiaryFromJson(Map<String, dynamic> json) {
  return Diary(
      title: json['title'] as String,
      content: json['content'] as String,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      isPositive: json['isPositive'] as bool);
}

Map<String, dynamic> _$DiaryToJson(Diary instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'date': instance.date?.toIso8601String(),
      'isPositive': instance.isPositive
    };
