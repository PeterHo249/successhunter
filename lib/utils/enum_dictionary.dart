import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabChoice {
  final String title;
  final Icon icon;
  final Widget action;

  const TabChoice({this.title, this.icon, this.action});
}

const List<TabChoice> choices = const <TabChoice>[
  const TabChoice(title: 'Home', icon: Icon(Icons.home)),
  const TabChoice(title: 'Goal', icon: Icon(FontAwesomeIcons.bullseye)),
  const TabChoice(title: 'Habit', icon: Icon(Icons.calendar_today)),
  const TabChoice(title: 'Diary', icon: Icon(FontAwesomeIcons.journalWhills)),
];

class MainPagePopupChoiceEnum {
  static const String addGoal = 'Add Goal';
  static const String addHabit = 'Add Habit';

  static const List<String> choices = <String>[
    addGoal,
    addHabit,
  ];
}

class GoalDetailPopupChoiceEnum {
  static const String addMilestone = 'Add Milestone';
  static const String editGoal = 'Edit Goal';
  static const String completeGoal = 'Complete Goal';
  static const String shareGoal = 'Share Goal';

  static const List<String> choices = <String>[
    addMilestone,
    editGoal,
    completeGoal,
    shareGoal,
  ];
}

class HabitDetailPopupChoiceEnum {
  static const String editHabit = 'Edit Habit';
  static const String completeHabit = 'Complete Today';
  static const String shareHabit = 'Share Habit';

  static const List<String> choices = <String>[
    editHabit,
    completeHabit,
    shareHabit,
  ];
}

class ActivityTypeEnum {
  static const String career = 'Career';
  static const String health = 'Health';
  static const String relationship = 'Relationship';
  static const String finance = 'Finance';
  static const String family = 'Family';
  static const String spirituality = 'Spirituality';
  static const String lifestyle = 'Lifestyle';
  static const String other = 'Other';

  static const List<String> types = <String>[
    career,
    health,
    relationship,
    finance,
    family,
    spirituality,
    lifestyle,
    other,
  ];

  static int getIndex(String type) {
    return types.indexOf(type);
  }
}

class TypeDecorationEnum {
  static const TypeDecoration career = TypeDecoration(
    icon: FontAwesomeIcons.briefcase,
    color: Colors.white,
    backgroundColor: Colors.blue,
  );
  static const TypeDecoration health = TypeDecoration(
    icon: FontAwesomeIcons.heartbeat,
    color: Colors.white,
    backgroundColor: Colors.green,
  );
  static const TypeDecoration relationship = TypeDecoration(
    icon: FontAwesomeIcons.heart,
    color: Colors.white,
    backgroundColor: Colors.red,
  );
  static const TypeDecoration finance = TypeDecoration(
    icon: FontAwesomeIcons.dollarSign,
    color: Colors.white,
    backgroundColor: Colors.deepPurple,
  );
  static const TypeDecoration family = TypeDecoration(
    icon: FontAwesomeIcons.users,
    color: Colors.white,
    backgroundColor: Colors.redAccent,
  );
  static const TypeDecoration spirituality = TypeDecoration(
    icon: FontAwesomeIcons.rebel,
    color: Colors.white,
    backgroundColor: Colors.amber,
  );
  static const TypeDecoration lifestyle = TypeDecoration(
    icon: Icons.directions_run,
    color: Colors.white,
    backgroundColor: Colors.lime,
  );
  static const TypeDecoration other = TypeDecoration(
    icon: FontAwesomeIcons.bullseye,
    color: Colors.white,
    backgroundColor: Colors.blueGrey,
  );

  static const List<TypeDecoration> typeDecorations = <TypeDecoration>[
    career,
    health,
    relationship,
    finance,
    family,
    spirituality,
    lifestyle,
    other,
  ];
}

class TypeDecoration {
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const TypeDecoration({this.icon, this.color, this.backgroundColor});
}

class ActivityState {
  static const int doing = 0;
  static const int done = 1;
  static const int failed = 2;
  static const int notToday = 3;
}

class RepetationTypeEnum {
  static const String everyDay = 'Every day';
  static const String dayOfWeek = 'Day of Week';
  static const String period = 'Period';

  static const List<String> types = <String>[
    everyDay,
    dayOfWeek,
    period,
  ];

  static int getIndex(String type) {
    return types.indexOf(type);
  }
}

class DayOfWeekEnum {
  static const String monday = 'Monday';
  static const String tuesday = 'Tuesday';
  static const String wednesday = 'Wednesday';
  static const String thursday = 'Thursday';
  static const String friday = 'Friday';
  static const String saturday = 'Saturday';
  static const String sunday = 'Sunday';

  static const List<String> days = <String>[
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday,
  ];
}
