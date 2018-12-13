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
      currentAvatar: json['currentAvatar'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'displayName': instance.displayName,
      'uid': instance.uid,
      'level': instance.level,
      'experience': instance.experience,
      'badges': instance.badges,
      'currentAvatar': instance.currentAvatar
    };
