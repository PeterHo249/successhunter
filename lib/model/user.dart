import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:successhunter/model/chart_data.dart';
import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:successhunter/model/avatar_list.dart' as Avatar;
import 'package:successhunter/model/badge_list.dart' as Badge;

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
  int habitCompletedCount;
  int goalCompleteCount;
  int coopCompleteCount;

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
    this.habitCompletedCount = 0,
    this.goalCompleteCount = 0,
    this.coopCompleteCount = 0,
  }) {
    if (badges == null) {
      badges = List<String>();
    }
    if (availableAvatars == null) {
      availableAvatars = <String>[];
      Avatar.avatarNames.forEach((key, value) {
        if (value == 1) {
          availableAvatars.add(key);
        }
      });
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

  void addHabitCount(BuildContext context) {
    habitCompletedCount++;
    String badge;
    String content;
    switch (habitCompletedCount) {
      case 1:
        badge = 'habit_1.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      case 5:
        badge = 'habit_5.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      case 10:
        badge = 'habit_10.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      case 50:
        badge = 'habit_50.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      case 100:
        badge = 'habit_100.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      default:
    }
  }

  void addGoalCount(BuildContext context) {
    goalCompleteCount++;
    String badge;
    String content;
    switch (goalCompleteCount) {
      case 1:
        badge = 'goal_1.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      case 5:
        badge = 'goal_5.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      case 10:
        badge = 'goal_10.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      case 50:
        badge = 'goal_50.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      case 100:
        badge = 'goal_100.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      default:
    }
  }

  void addCoopCount(BuildContext context) {
    coopCompleteCount++;
    String badge;
    String content;
    switch (coopCompleteCount) {
      case 1:
        badge = 'coop_1.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      case 5:
        badge = 'coop_5.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      case 10:
        badge = 'coop_10.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      case 50:
        badge = 'coop_50.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      case 100:
        badge = 'coop_100.png';
        badges.add(badge);
        content = 'Congratulation!\n${Badge.badgeNames[badge]}';
        Helper.showLevelUpDialog(
          context,
          this,
          imagePaths: <String>[
            'assets/badge/$badge',
          ],
          content: content,
        );
        break;
      default:
    }
  }

  bool addExperience(BuildContext context, int amount) {
    experience += amount;
    if (experience >= level * 50) {
      experience -= level * 50;
      level++;
      var levelMilestone = Avatar.avatarNames.values.toList();
      if (levelMilestone.contains(level)) {
        List<String> avatarImage = <String>[];
        Avatar.avatarNames.forEach((key, value) {
          if (value == level) {
            avatarImage.add(key);
          }
        });
        availableAvatars.addAll(avatarImage);
        var imagePaths =
            avatarImage.map((image) => 'assets/avatar/$image').toList();
        String content = '';
        switch (level) {
          case 2:
            badges.add('level_1.png');
            imagePaths.add('assest/badge/level_1.png');
            content =
                'Congratulation! You\'ve just reached level $level and got some new avatars, badge.';
            break;
          case 10:
            badges.add('level_10.png');
            imagePaths.add('assest/badge/level_10.png');
            content =
                'Congratulation! You\'ve just reached level $level and got some new avatars, badge.';
            break;
          case 20:
            badges.add('level_20.png');
            imagePaths.add('assest/badge/level_20.png');
            content =
                'Congratulation! You\'ve just reached level $level and got some new avatars, badge.';
            break;
          case 30:
            badges.add('level_30.png');
            imagePaths.add('assest/badge/level_30.png');
            content =
                'Congratulation! You\'ve just reached level $level and got some new avatars, badge.';
            break;
          case 40:
            badges.add('level_40.png');
            imagePaths.add('assest/badge/level_40.png');
            content =
                'Congratulation! You\'ve just reached level $level and got some new avatars, badge.';
            break;
          case 50:
            badges.add('level_50.png');
            imagePaths.add('assest/badge/level_50.png');
            content =
                'Congratulation! You\'ve just reached level $level and got some new avatars, badge.';
            break;
        }
        Helper.showLevelUpDialog(
          context,
          this,
          content: content.isEmpty
              ? 'Congratulation! You\'ve just reached level $level and got some new avatars.'
              : content,
          imagePaths: imagePaths,
        );
      } else {
        Helper.showLevelUpDialog(context, this);
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

  factory CompactUser.fromJson(Map<String, dynamic> json) =>
      _$CompactUserFromJson(json);

  Map<String, dynamic> toJson() => _$CompactUserToJson(this);
}
