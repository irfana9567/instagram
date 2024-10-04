
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PostModel chatModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String chatModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  String uId;
  String id;
  String userName;
  String name;
  String userProfile;
  String userBio;
  String image;
  int likeCount;
  bool delete;
  String description;
  List<dynamic> like;
  List<dynamic> saveUser;
  DateTime uploadDate;
  DocumentReference? reference;

  PostModel({
    required this.uId,
    required this.id,
    required this.userName,
    required this.name,
    required this.userProfile,
    required this.userBio,
    required this.image,
    required this.likeCount,
    required this.delete,
    required this.description,
    required this.like,
    required this.saveUser,
    required this.uploadDate,
    required this.reference,
  });

  PostModel copyWith({
    String? uId,
    String? id,
    String? userName,
    String? name,
    String? userProfile,
    String? userBio,
    String? image,
    int? likeCount,
    bool? delete,
    String? description,
    List<dynamic>? like,
    List<dynamic>? saveUser,
    DateTime? uploadDate,
    DateTime? storyUploadDate,
    DocumentReference? reference,
  }) =>
      PostModel(
        uId: uId ?? this.uId,
        id: id ?? this.id,
        userName: userName ?? this.userName,
        name: name ?? this.name,
        userProfile: userProfile ?? this.userProfile,
        userBio: userBio ?? this.userBio,
        image: image ?? this.image,
        likeCount: likeCount ?? this.likeCount,
        delete: delete ?? this.delete,
        description: description ?? this.description,
        like: like ?? this.like,
        saveUser: saveUser ?? this.saveUser,
        uploadDate: uploadDate ?? this.uploadDate,
        reference: reference ?? this.reference,
      );

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    uId: json["uId"],
    id: json["id"],
    userName: json["userName"],
    name: json["name"],
    userProfile: json["userProfile"],
    userBio: json["userBio"],
    image: json["image"],
    likeCount: json["likeCount"],
    delete: json["delete"],
    description: json["description"],
    like: List<dynamic>.from(json["like"].map((x) => x)),
    saveUser: List<dynamic>.from(json["saveUser"].map((x) => x)),
    reference: json["reference"],
    uploadDate: DateTime.parse(json["uploadDate"]),
  );

  Map<String, dynamic> toJson() => {
    "uId": uId,
    "id": id,
    "userName": userName,
    "name": name,
    "userProfile": userProfile,
    "userBio": userBio,
    "image": image,
    "likeCount": likeCount,
    "delete": delete,
    "description": description,
    "like": List<dynamic>.from(like.map((x) => x)),
    "saveUser": List<dynamic>.from(saveUser.map((x) => x)),
    "reference": reference,
    "uploadDate": uploadDate.toIso8601String(),
  };
}
