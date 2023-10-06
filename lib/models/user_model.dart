import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String profilePicture;
  final String banner;
  final String uid;
  final bool isAuthenticated;
  final int action;
  final List<String> awards;

  UserModel({
    required this.name,
    required this.profilePicture,
    required this.banner,
    required this.uid,
    required this.isAuthenticated,
    required this.action,
    required this.awards
});

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? banner,
    String? uid,
    bool? isAuthenticated,
    int? action,
    List<String>? awards,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePicture: profilePic ?? this.profilePicture,
      banner: banner ?? this.banner,
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      action: action ?? this.action,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePicture,
      'banner': banner,
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'action': action,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      profilePicture: map['profilePic'] ?? '',
      banner: map['banner'] ?? '',
      uid: map['uid'] ?? '',
      isAuthenticated: map['isAuthenticated'] ?? false,
      action: map['action']?.toInt() ?? 0,
      awards: List<String>.from(map['awards']),
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, profilePic: $profilePicture, banner: $banner, uid: $uid, isAuthenticated: $isAuthenticated, action: $action, awards: $awards)';
  }


  // useful for comparison with other object
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.profilePicture == profilePicture &&
        other.banner == banner &&
        other.uid == uid &&
        other.isAuthenticated == isAuthenticated &&
        other.action == action &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return name.hashCode ^
    profilePicture.hashCode ^
    banner.hashCode ^
    uid.hashCode ^
    isAuthenticated.hashCode ^
    action.hashCode ^
    awards.hashCode;
  }
}