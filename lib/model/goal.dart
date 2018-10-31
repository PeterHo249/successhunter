import 'dart:core';

class Goal {

  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final double donePercent;

  Goal({this.title, this.description, this.startDate, this.endDate, this.donePercent});
}