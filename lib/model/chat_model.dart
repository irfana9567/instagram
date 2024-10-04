
import 'package:meta/meta.dart';
import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  String id;
  String senderId;
  String receiverId;
  String message;
  String reply;
  String messageType;
  bool delete;
  bool read;
  DateTime dateTime;

  ChatModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.reply,
    required this.messageType,
    required this.delete,
    required this.read,
    required this.dateTime,
  });

  ChatModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    String? reply,
    String? messageType,
    bool? delete,
    bool? read,
    DateTime? dateTime,
  }) =>
      ChatModel(
        id: id ?? this.id,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        message: message ?? this.message,
        reply: reply ?? this.reply,
        messageType: messageType ?? this.messageType,
        delete: delete ?? this.delete,
        read: read ?? this.read,
        dateTime: dateTime ?? this.dateTime,
      );

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    id: json["id"],
    senderId: json["senderId"],
    receiverId: json["receiverId"],
    message: json["message"],
    reply: json["reply"],
    messageType: json["messageType"],
    delete: json["delete"],
    read: json["read"],
    dateTime: DateTime.parse(json["dateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "senderId": senderId,
    "receiverId": receiverId,
    "message": message,
    "reply": reply,
    "messageType": messageType,
    "delete": delete,
    "read": read,
    "dateTime": dateTime.toIso8601String(),
  };
}
