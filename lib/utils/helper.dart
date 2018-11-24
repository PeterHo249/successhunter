import 'package:flutter/material.dart';
import 'package:successhunter/utils/enum_dictionary.dart';

Color getStateBackgroundColor(int state) {
  switch (state) {
    case ActivityState.done:
      return Colors.green[50];
    case ActivityState.doing:
      return Colors.white;
    case ActivityState.failed:
      return Colors.red[50];
  }

  return Colors.grey[200];
}