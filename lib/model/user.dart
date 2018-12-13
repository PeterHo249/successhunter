import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String displayName;
  String uid;
  int level;
  int experience;
  List<String> badges;
  String currentAvatar;

  User({this.displayName = '', this.uid = '', this.level = 1, this.experience = 0, this.badges, this.currentAvatar = 'avatar_1',}) {
    if (badges == null) {
      badges = List<String>();
    }
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class UserDocument {
  final User item;
  final String documentId;

  UserDocument({this.item, this.documentId});
}