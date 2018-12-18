import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

const Map<String, int> avatarNames = {
  'kid_1.png': 1,
  'kid_2.png': 4,
  'kid_3.png': 7,
  'kid_4.png': 1,
  'kid_5.png': 4,
  'kid_6.png': 7,
  'student_1.png': 10,
  'student_2.png': 14,
  'student_3.png': 17,
  'student_4.png': 10,
  'student_5.png': 14,
  'student_6.png': 17,
  'teenager_1.png': 20,
  'teenager_2.png': 24,
  'teenager_3.png': 27,
  'teenager_4.png': 20,
  'teenager_5.png': 24,
  'teenager_6.png': 27,
  'officer_1.png': 30,
  'officer_2.png': 34,
  'officer_3.png': 37,
  'officer_4.png': 30,
  'officer_5.png': 34,
  'officer_6.png': 37,
  'boss_1.png': 40,
  'boss_2.png': 45,
  'boss_3.png': 40,
};

const Map<String, String> badgeNames = {
  'coop_1.png': 'You have finished a co-op goal.',
  'coop_5.png': 'You have finished 5 co-op goals.',
  'coop_10.png': 'You have finished 10 co-op goals.',
  'coop_50.png': 'You have finished 50 co-op goals.',
  'coop_100.png': 'You have finished 100 co-op goals.',
  'goal_1.png': 'You have finished a goal.',
  'goal_5.png': 'You have finished 5 goals.',
  'goal_10.png': 'You have finished 10 goals.',
  'goal_50.png': 'You have finished 50 goals.',
  'goal_100.png': 'You have finished 100 goals.',
  'habit_1.png': 'You have finished a habit task.',
  'habit_5.png': 'You have finished 5 habit tasks.',
  'habit_10.png': 'You have finished 10 habit tasks.',
  'habit_50.png': 'You have finished 50 habit tasks.',
  'habit_100.png': 'You have finished 100 habit tasks.',
  'streak_5.png': 'You have completed a 5-time streak.',
  'streak_10.png': 'You have completed a 10-time streak.',
  'streak_50.png': 'You have completed a 50-time streak.',
  'streak_100.png': 'You have completed a 100-time streak.',
  'level_1.png': 'You have leveled up',
  'level_10.png': 'You have reached level 10.',
  'level_20.png': 'You have reached level 20.',
  'level_30.png': 'You have reached level 30.',
  'level_40.png': 'You have reached level 40.',
  'level_50.png': 'You have reached level 50.',
};
