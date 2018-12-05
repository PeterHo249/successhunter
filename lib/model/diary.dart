import 'package:json_annotation/json_annotation.dart';

part 'diary.g.dart';

@JsonSerializable()
class Diary {
  String title;
  String content;
  DateTime date;
  bool isPositive;

  Diary({this.title, this.content, this.date, this.isPositive}) {
    if (date == null) {
      date = DateTime.now().toUtc();
    }
  }

  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryToJson(this);
}