// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';
import 'dart:convert';

StoryModel chatModelFromJson(String str) => StoryModel.fromJson(json.decode(str));

String chatModelToJson(StoryModel data) => json.encode(data.toJson());

class StoryModel {
  String uId;
  String mId;
  String media;
  String userName;
  String userProfile;
  DateTime createdAt;
  bool delete;
  // Duration duration;

  StoryModel({
    required this.uId,
    required this.mId,
    required this.media,
    required this.userProfile,
    required this.userName,
    required this.createdAt,
    required this.delete,
    // required this.duration,
  });

  StoryModel copyWith({
    String? uId,
    String? mId,
    String? media,
    String? userName,
    String? userProfile,
    DateTime? createdAt,
    bool? delete,
    // Duration? duration,
  }) =>
      StoryModel(
        uId: uId ?? this.uId,
        mId: mId ?? this.mId,
        media: media ?? this.media,
        userName: userName ?? this.userName,
        userProfile: userProfile ?? this.userProfile,
        createdAt: createdAt ?? this.createdAt,
        delete: delete ?? this.delete,
        // duration: duration ?? this.duration,
      );

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
    uId: json["uId"],
    mId: json["mId"],
    media: json["media"],
    userName: json["userName"],
    userProfile: json["userProfile"],
    createdAt: DateTime.parse(json["createdAt"]),
    delete: json["delete"],
    // duration: json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "uId": uId,
    "mId": mId,
    "media": media,
    "userName": userName,
    "userProfile": userProfile,
    "createdAt": createdAt.toIso8601String(),
    "delete": delete,
    // "duration": duration,
  };
}
