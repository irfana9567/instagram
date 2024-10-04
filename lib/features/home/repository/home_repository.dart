import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:instagram/common/providers/firebase_providers.dart';
import 'package:instagram/model/comment_model.dart';
import 'package:instagram/model/post_model.dart';
import 'package:instagram/model/story_model.dart';
import 'package:instagram/model/user_model.dart';

import '../../../model/chat_model.dart';

final homeRepositoryProvider=Provider((ref) => HomeRepository(firestore: ref.watch(fireStoreProvider)),);

class HomeRepository{
  final FirebaseFirestore _firestore;

  HomeRepository({required  FirebaseFirestore firestore}):_firestore=firestore;

  /// get user data
Future<UserModel> getUser(String uid)async{
  try{
    final querySnapshot=await _firestore.collection('users').doc(uid).get();

    if(querySnapshot.exists){
      return UserModel.fromMap(querySnapshot.data()!);
    }else{
      return UserModel.fromMap({});
    }
  }catch (e){
    print("Error fetching user data:$e");
    return UserModel.fromMap({});
  }
}

/// update user data
  Future updateUserdata({required String uid, required UserModel userModel,}) async {
    try {
      return right(_firestore.collection("users").doc(uid).update(userModel.toMap()));
    } catch (e) {
      return left(e.toString());
    }
  }

/// stream users
Stream<List<UserModel>> getUsers(String search){
  return _firestore.collection('users')
      .where('search',arrayContains: search.isEmpty?null:search.toUpperCase())
      .snapshots().map((event) =>
      event.docs.map((e) => UserModel.fromMap(e.data())).toList(),);
}
///add chats
 Future<Object> addChats({required ChatModel chatmodel})async{
try{
  DocumentReference reference=_firestore.collection('users').doc(currentUserId).collection("chats").doc();
  ChatModel chatData=chatmodel.copyWith(
    id: reference.id
  );
 return Right(reference.set(chatData.toJson()));


}catch (e){
  return Left(e.toString());
}
}
///add replymessage
  Future addReply(String uId, ChatModel chatModel) async {
    try {
      return right(_firestore.collection("users").doc(uId).collection("chats").doc().update(chatModel.toJson()));
    } catch (e) {
      return left(e.toString());
    }
  }

///stream messages
Stream<List<ChatModel>> getMessages(){
  return _firestore.collection("users").doc(currentUserId).collection("chats").orderBy('dateTime',descending: true).snapshots().map((event) =>
    event.docs.map((e) => ChatModel.fromJson(e.data()),).toList(),);
}
///delete messages
Future<void> deleteMsg(String docId)async{
  try{
    await _firestore.collection('users').doc(currentUserId).collection('chats').doc(docId).update({
      "delete":true,
    });
  }on FirebaseException catch (e){
    print(e);
    throw e.message ?? "";
  }
}

///add post
addPosts( {required PostModel postModel}){
  try{
    DocumentReference reference=_firestore.collection("post").doc();
    PostModel postModelData=postModel.copyWith(
      id: reference.id,
      reference: reference,
    );
    return Right(reference.set(postModelData.toJson()));


  }catch (e){
    return Left(e.toString());
  }
}
///stream post
Stream<List<PostModel>> getPosts(){
  return _firestore.collection('post').where('delete',isEqualTo: false).orderBy('uploadDate',descending: true).snapshots().map((event) =>
      event.docs.map((e) => PostModel.fromJson(e.data()),).toList(),);
}
///update post


  /// delete post
  Future<void> deletePost(String docId) async {
    try {
      await _firestore.collection("post").doc(docId).update({
        "delete": true,
      });
    } on FirebaseException catch (e) {
      print(e);
      throw e.message ?? "";
    }
  }

///upload stories
uploadStories({required StoryModel storyModel}){
  try{
    DocumentReference reference=_firestore.collection("stories").doc();
    StoryModel storyModelData=storyModel.copyWith(
      mId: reference.id
    );
    return right(reference.set(storyModelData.toJson()));
  } catch(e){
    return left(e.toString());
  }
}

///stream stories
Stream<List<StoryModel>> getStories(){
  return _firestore.collection('stories').where("uId",isNotEqualTo: currentUserId).orderBy('createdAt',descending: false).snapshots().map((event)=>
      event.docs.map((e) => StoryModel.fromJson(e.data()),).toList(),);
}
///stream your story
Stream<List<StoryModel>> getYourStory(){
  return _firestore.collection('stories').where("uId",isEqualTo: currentUserId).where("delete",isEqualTo: false).snapshots().map((event)=>
      event.docs.map((e) => StoryModel.fromJson(e.data()),).toList(),);
}
///delete story
  Future<void> deleteStory(String docId) async {
      try {
        await _firestore.collection("stories").doc(docId).update({
          "delete": true,
        });
      } on FirebaseException catch (e) {
        print(e);
        throw e.message ?? "";
      }
    }
/// add comments
  Future<Object> addComments(String pId,{required CommentModel commentModel})async{
    try{
      DocumentReference reference=_firestore.collection('post').doc(pId).collection("comments").doc();
      CommentModel commentData=commentModel.copyWith(
          commentId: reference.id
      );
      return Right(reference.set(commentData.toJson()));
    }catch (e){
      return Left(e.toString());
    }
  }

///stream comments

Stream<List<CommentModel>> getComments(){
  return _firestore.collection("post").doc()
      .collection("comments")
      .orderBy('date',descending: true).snapshots().map((event) =>
    event.docs.map((e) => CommentModel.fromJson(e.data()),).toList(),);
}
/// get follow user
  Future<UserModel> getfollowUser(String uid)async{
    try{
      final querySnapshot=await _firestore.collection('users').doc(uid).get();

      if(querySnapshot.exists){
        return UserModel.fromMap(querySnapshot.data()!);
      }else{
        return UserModel.fromMap({});
      }
    }catch (e){
      print("Error fetching user data:$e");
      return UserModel.fromMap({});
    }
  }
  ///delete comment
  Future<void> deleteComment(String cId,String pId)async{
    try{
      await _firestore.collection('post').doc(pId).collection('comments').doc(cId).update({
        "delete":true,
      });
    }on FirebaseException catch (e){
      print(e);
      throw e.message ?? "";
    }
  }
///stream likedPost
  Stream<List<PostModel>> likedPost(){
    return _firestore.collection('post').where("like",arrayContains: currentUserId).where('delete',isEqualTo: false).snapshots().map((event) =>
        event.docs.map((e) => PostModel.fromJson(e.data()),).toList(),);
  }
  ///stream your comments
  Stream<List<CommentModel>> yourComments(){
    return _firestore.collection("post").doc()
        .collection("comments")
        .where("userId",isEqualTo: currentUserId)
        .where('delete',isEqualTo: false)
        .snapshots().map((event) =>
        event.docs.map((e) => CommentModel.fromJson(e.data()),).toList(),);
  }

}
