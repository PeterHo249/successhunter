import 'package:json_annotation/json_annotation.dart';
import 'package:successhunter/model/chart_data.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String displayName;
  String uid;
  int level;
  int experience;
  List<String> badges;
  List<String> availableAvatars;
  String currentAvatar;
  String email;
  List<TaskCountPerDate> goalCounts;
  List<TaskCountPerDate> habitCounts;

  User({
    this.displayName = '',
    this.uid = '',
    this.level = 1,
    this.experience = 0,
    this.badges,
    this.currentAvatar = 'kid_1.png',
    this.availableAvatars,
    this.goalCounts,
    this.habitCounts,
    this.email = '',
  }) {
    if (badges == null) {
      badges = List<String>();
    }
    if (availableAvatars == null) {
      availableAvatars = <String>['kid_1.png', 'kid_4.png'];
    }
    if (goalCounts == null) {
      goalCounts = List<TaskCountPerDate>();
    }
    if (habitCounts == null) {
      habitCounts = List<TaskCountPerDate>();
    }
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  bool addExperience(int amount) {
    experience += amount;
    if (experience >= level * 50) {
      experience -= level * 50;
      level++;
      switch (level) {
        case 4:
          availableAvatars.add('kid_2.png');
          availableAvatars.add('kid_5.png');
          break;
        case 7:
          availableAvatars.add('kid_3.png');
          availableAvatars.add('kid_6.png');
          break;
        case 10:
          availableAvatars.add('student_1.png');
          availableAvatars.add('student_4.png');
          break;
        case 14:
          availableAvatars.add('student_2.png');
          availableAvatars.add('student_5.png');
          break;
        case 17:
          availableAvatars.add('student_3.png');
          availableAvatars.add('student_6.png');
          break;
        case 20:
          availableAvatars.add('teenager_1.png');
          availableAvatars.add('teenager_4.png');
          break;
        case 24:
          availableAvatars.add('teenager_2.png');
          availableAvatars.add('teenager_5.png');
          break;
        case 27:
          availableAvatars.add('teenager_3.png');
          availableAvatars.add('teenager_6.png');
          break;
        case 30:
          availableAvatars.add('officer_1.png');
          availableAvatars.add('officer_4.png');
          break;
        case 34:
          availableAvatars.add('officer_2.png');
          availableAvatars.add('officer_5.png');
          break;
        case 37:
          availableAvatars.add('officer_3.png');
          availableAvatars.add('officer_6.png');
          break;
        case 40:
          availableAvatars.add('boss_1.png');
          availableAvatars.add('boss_3.png');
          break;
        case 45:
          availableAvatars.add('boss_2.png');
          break;
        default:
      }
      return true;
    }

    return false;
  }
}

class UserDocument {
  final User item;
  final String documentId;

  UserDocument({this.item, this.documentId});
}
