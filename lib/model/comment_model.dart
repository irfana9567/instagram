
import 'dart:convert';

CommentModel commentModelFromJson(String str) => CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  String commentId;
  String postId;
  String userId;
  String userName;
  String userProfile;
  String comment;
  List<dynamic>? like;
  DateTime date;
  bool delete;

  CommentModel({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userProfile,
    required this.comment,
    required this.like,
    required this.date,
    required this.delete,
  });

  CommentModel copyWith({
    String? commentId,
    String? postId,
    String? userId,
    String? userName,
    String? userProfile,
    String? comment,
    List<dynamic>? like,
    DateTime? date,
    bool? delete,
  }) =>
      CommentModel(
        commentId: commentId ?? this.commentId,
        postId: postId ?? this.postId,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userProfile: userProfile ?? this.userProfile,
        comment: comment ?? this.comment,
        date: date ?? this.date,
        like: like ?? this.like,
        delete: delete ?? this.delete,
      );

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    commentId: json["commentId"],
    postId: json["postId"],
    userId: json["userId"],
    userName: json["userName"],
    userProfile: json["userProfile"],
    comment: json["comment"],
    like: List<dynamic>.from(json["like"].map((x) => x)),
    date: DateTime.parse(json["date"]),
    delete: json["delete"],
  );

  Map<String, dynamic> toJson() => {
    "commentId": commentId,
    "postId": postId,
    "userId": userId,
    "userName": userName,
    "userProfile": userProfile,
    "comment": comment,
    "delete": delete,
    "like": List<dynamic>.from(like!.map((x) => x)),
    "date": date.toIso8601String(),
  };
}
