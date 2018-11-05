import 'dart:core';

class Habit {
  final String title;
  final String description;
  final bool isYesNoTask;

  Habit({this.title, this.description, this.isYesNoTask = true});
}