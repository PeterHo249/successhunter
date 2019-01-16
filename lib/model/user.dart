import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:successhunter/model/chart_data.dart';
import 'package:successhunter/utils/helper.dart' as Helper;

part 'user.g.dart';

@JsonSerializable()
class User {
  String displayName;
  String photoUrl;
  String uid;
  int level;
  int experience;
  List<String> badges;
  List<String> availableAvatars;
  String currentAvatar;
  String email;
  List<TaskCountPerDate> goalCounts;
  List<TaskCountPerDate> habitCounts;
  String diaryPin;
  List<String> fcmToken;

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
    this.diaryPin = '',
    this.fcmToken,
    this.photoUrl,
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
    if (fcmToken == null) {
      fcmToken = List<String>();
    }
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  bool addExperience(BuildContext context, int amount) {
    experience += amount;
    if (experience >= level * 50) {
      experience -= level * 50;
      level++;
      switch (level) {
        case 4:
          availableAvatars.add('kid_2.png');
          availableAvatars.add('kid_5.png');
          Helper.showLevelUpDialog(
            context,
            this,
            content:
                'Congratulation! You\'ve just reached level 4 and got some new avatars.',
            imagePaths: <String>[
              'assets/avatar/kid_2.png',
              'assets/avatar/kid_5.png',
            ],
          );
          break;
        case 7:
          availableAvatars.add('kid_3.png');
          availableAvatars.add('kid_6.png');
          Helper.showLevelUpDialog(
            context,
            this,
            content:
                'Congratulation! You\'ve just reached level 7 and got some new avatars.',
            imagePaths: <String>[
              'assets/avatar/kid_3.png',
              'assets/avatar/kid_6.png',
            ],
          );
          break;
        case 10:
          availableAvatars.add('student_1.png');
          availableAvatars.add('student_4.png');
          badges.add('level_10.png');
          Helper.showLevelUpDialog(
            context,
            this,
            content:
                'Congratulation! You\'ve just reached level 10 and got some new avatars, badges.',
            imagePaths: <String>[
              'assets/avatar/student_1.png',
              'assets/avatar/student_4.png',
              'assets/badge/level_10.png',
            ],
          );
          break;
        case 14:
          availableAvatars.add('student_2.png');
          availableAvatars.add('student_5.png');
          Helper.showLevelUpDialog(
            context,
            this,
            content:
                'Congratulation! You\'ve just reached level 14 and got some new avatars.',
            imagePaths: <String>[
              'assets/avatar/student_2.png',
              'assets/avatar/student_5.png',
            ],
          );
          break;
        case 17:
          availableAvatars.add('student_3.png');
          availableAvatars.add('student_6.png');
          Helper.showLevelUpDialog(
            context,
            this,
            content:
                'Congratulation! You\'ve just reached level 17 and got some new avatars.',
            imagePaths: <String>[
              'assets/avatar/student_3.png',
              'assets/avatar/student_6.png',
            ],
          );
          break;
        case 20:
          availableAvatars.add('teenager_1.png');
          availableAvatars.add('teenager_4.png');
          badges.add('level_20.png');
          Helper.showLevelUpDialog(
            context,
            this,
            content:
                'Congratulation! You\'ve just reached level 20 and got some new avatars, badges.',
            imagePaths: <String>[
              'assets/avatar/teenager_1.png',
              'assets/avatar/teenager_4.png',
              'assets/badge/level_20.png',
            ],
          );
          break;
        case 24:
          availableAvatars.add('teenager_2.png');
          availableAvatars.add('teenager_5.png');
          Helper.showLevelUpDialog(
            context,
            this,
            content:
                'Congratulation! You\'ve just reached level 24 and got some new avatars.',
            imagePaths: <String>[
              'assets/avatar/teenager_2.png',
              'assets/avatar/teenager_5.png',
            ],
          );
          break;
        case 27:
          availableAvatars.add('teenager_3.png');
          availableAvatars.add('teenager_6.png');
          Helper.showLevelUpDialog(
            context,
            this,
            content:
                'Congratulation! You\'ve just reached level 27 and got some new avatars.',
            imagePaths: <String>[
              'assets/avatar/teenager_3.png',
              'assets/avatar/teenager_6.png',
            ],
          );
          break;
        case 30:
          availableAvatars.add('officer_1.png');
          availableAvatars.add('officer_4.png');
          badges.add('level_30.png');
          Helper.showLevelUpDialog(
            context,
            this,
            content:
                'Congratulation! You\'ve just reached level 30 and got some new avatars, badges.',
            imagePaths: <String>[
              'assets/avatar/officer_1.png',
              'assets/avatar/officer_4.png',
              'assets/badge/level_30.png',
            ],
          );
          break;
        case 34:
          availableAvatars.add('officer_2.png');
          availableAvatars.add('officer_5.png');
          Helper.showLevelUpDialog(
            context,
            this,
            content:
                'Congratulation! You\'ve just reached level 34 and got some new avatars.',
            imagePaths: <String>[
              'assets/avatar/officer_2.png',
              'assets/avatar/officer_5.png',
            ],
          );
          break;
        case 37:
          availableAvatars.add('officer_3.png');
          availableAvatars.add('officer_6.png');
          Helper.showLevelUpDialog(
            context,
            this,
            content:
                'Congratulation! You\'ve just reached level 37 and got some new avatars.',
            imagePaths: <String>[
              'assets/avatar/officer_3.png',
              'assets/avatar/officer_4.png',
            ],
          );
          break;
        case 40:
          availableAvatars.add('boss_1.png');
          availableAvatars.add('boss_3.png');
          badges.add('level_40.png');
          Helper.showLevelUpDialog(
            context,
            this,
            content:
                'Congratulation! You\'ve just reached level 40 and got some new avatars, badges.',
            imagePaths: <String>[
              'assets/avatar/boss_1.png',
              'assets/avatar/boss_3.png',
              'assets/badge/level_40.png',
            ],
          );
          break;
        case 45:
          availableAvatars.add('boss_2.png');
          Helper.showLevelUpDialog(
            context,
            this,
            content:
                'Congratulation! You\'ve just reached level 45 and got some new avatars.',
            imagePaths: <String>[
              'assets/avatar/boss_2.png',
            ],
          );
          break;
        case 50:
          badges.add('level_50.png');
          Helper.showLevelUpDialog(
            context,
            this,
            content:
                'Congratulation! You\'ve just reached level 50 and got some new bagdes.',
            imagePaths: <String>[
              'assets/badge/level_50.png',
            ],
          );
          break;
        default:
          Helper.showLevelUpDialog(context, this);
          break;
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

@JsonSerializable()
class CompactUser {
  final String displayName;
  final String photoUrl;
  final String uid;

  CompactUser({this.displayName, this.photoUrl, this.uid});

  factory CompactUser.fromJson(Map<String, dynamic> json) => _$CompactUserFromJson(json);

  Map<String, dynamic> toJson() => _$CompactUserToJson(this);
}
