import 'package:cloud_firestore/cloud_firestore.dart';
UserModel? currentUser;
String currentUserId="";

class UserModel{
  String userName;
  String name;
  String bio;
  String gender;
  String email;
  String password;
  String id;
  String profile;
  List<dynamic> following;
  List<dynamic> followers;
  List? search;
  DocumentReference? reference;
  UserModel({
    required this.userName,
    required this.name,
    required this.bio,
    required this.gender,
    required this.email,
    required this.password,
    required this.id,
    required this.profile,
    required this.following,
    required this.followers,
    this.search,
    required this.reference,
  });

  Map<String,dynamic> toMap(){
    return{
      'userName':this.userName,
      'name':this.name,
      'bio':this.bio,
      'gender':this.gender,
      'email':this.email,
      'password':this.password,
      'id':this.id,
      'profile':this.profile,
      'following':this.following,
      'followers':this.followers,
      'search':this.search,
      'reference':this.reference,
    };
  }
  factory UserModel.fromMap(Map<String,dynamic>map){
    return UserModel(
      userName: map['userName']??"",
      name: map['name']??"",
      bio: map['bio']??"",
      gender: map['gender']??"",
      email: map['email']??"",
      password: map['password']??"",
      id: map['id']??"",
      profile: map['profile']??"",
      following: map['following']??[],
      followers: map['followers']??[],
      search: map['search']??[],
      reference: map['reference']??"",
    );
  }

  UserModel copyWith({
    String? userName,
    String? name,
    String? bio,
    String? gender,
    String? password,
    String? email,
    String? id,
    String? profile,
    List<dynamic>?following,
    List<dynamic>? followers,
    List? search,
    DocumentReference? reference,
  }){
    return UserModel(
      userName: userName ?? this.userName,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      password: password ?? this.password,
      id: id ?? this.id,
      profile: profile ?? this.profile,
      reference: reference ?? this.reference,
      following: following?? this.following,
      followers: followers?? this.followers,
      search: search?? this.search,
    );
  }
}