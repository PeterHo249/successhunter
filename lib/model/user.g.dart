// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      displayName: json['displayName'] as String,
      uid: json['uid'] as String,
      level: json['level'] as int,
      experience: json['experience'] as int,
      badges: (json['badges'] as List)?.map((e) => e as String)?.toList(),
      currentAvatar: json['currentAvatar'] as String,
      availableAvatars:
          (json['availableAvatars'] as List)?.map((e) => e as String)?.toList(),
      goalCounts: (json['goalCounts'] as List)
          ?.map((e) => e == null
              ? null
              : TaskCountPerDate.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      habitCounts: (json['habitCounts'] as List)
          ?.map((e) => e == null
              ? null
              : TaskCountPerDate.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      email: json['email'] as String,
      diaryPin: json['diaryPin'] as String,
      fcmToken: (json['fcmToken'] as List)?.map((e) => e as String)?.toList(),
      photoUrl: json['photoUrl'] as String,
      habitCompletedCount: json['habitCompletedCount'] as int,
      goalCompleteCount: json['goalCompleteCount'] as int,
      coopCompleteCount: json['coopCompleteCount'] as int);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'uid': instance.uid,
      'level': instance.level,
      'experience': instance.experience,
      'badges': instance.badges,
      'availableAvatars': instance.availableAvatars,
      'currentAvatar': instance.currentAvatar,
      'email': instance.email,
      'goalCounts': instance.goalCounts,
      'habitCounts': instance.habitCounts,
      'diaryPin': instance.diaryPin,
      'fcmToken': instance.fcmToken,
      'habitCompletedCount': instance.habitCompletedCount,
      'goalCompleteCount': instance.goalCompleteCount,
      'coopCompleteCount': instance.coopCompleteCount
    };

CompactUser _$CompactUserFromJson(Map<String, dynamic> json) {
  return CompactUser(
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String,
      uid: json['uid'] as String);
}

Map<String, dynamic> _$CompactUserToJson(CompactUser instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'uid': instance.uid
    };
