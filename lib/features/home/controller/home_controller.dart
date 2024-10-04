import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:instagram/common/constants/text.dart';
import 'package:instagram/features/auth/repository/auth_repository.dart';
import 'package:instagram/features/home/repository/home_repository.dart';
import 'package:instagram/features/home/screen/home_screen.dart';
import 'package:instagram/features/home/screen/edit_profile.dart';
import 'package:instagram/features/home/screen/user_profiles/screen/user_account.dart';
import 'package:instagram/model/chat_model.dart';
import 'package:instagram/model/comment_model.dart';
import 'package:instagram/model/post_model.dart';
import 'package:instagram/model/story_model.dart';
import 'package:instagram/model/user_model.dart';
import 'package:instagram/navigation/home_page.dart';

final homeControllerProvider=StateNotifierProvider<HomeController, bool>((ref) {
  return HomeController(
    homeRepository: ref.watch(homeRepositoryProvider),
    ref: ref,
  );
});

final getUsersStream = StreamProvider.family<List<UserModel>,String>((ref,String data) {
  final controller = ref.watch(homeControllerProvider.notifier);
  return controller.getUsers(data);
});

final getmsgStream = StreamProvider.family<List<ChatModel>,String>((ref,String data) {
  final controller = ref.watch(homeControllerProvider.notifier);
  return controller.getMessages();
});

final getMsg=StreamProvider((ref) => ref.watch(homeControllerProvider.notifier).getMessages(),);
final getComments=StreamProvider((ref) => ref.watch(homeControllerProvider.notifier).getComments(),);
final getPost=StreamProvider((ref) => ref.watch(homeControllerProvider.notifier).getPosts(),);
final getStory=StreamProvider((ref) => ref.watch(homeControllerProvider.notifier).getStories(),);
final yourStory=StreamProvider((ref) => ref.watch(homeControllerProvider.notifier).getYourStory(),);
final likedPosts=StreamProvider((ref) => ref.watch(homeControllerProvider.notifier).likedPost(),);
final yourComment=StreamProvider((ref) => ref.watch(homeControllerProvider.notifier).yourComments(),);
// final getUsersStreamProvider = StreamProvider.autoDispose.family((ref,search) => ref.watch(homeControllerProvider.notifier).getUsers(search));

class HomeController extends StateNotifier<bool>{
  final HomeRepository _homeRepository;
  final Ref _ref;
  HomeController({required HomeRepository homeRepository,required Ref ref}):
        _homeRepository=homeRepository,
        _ref=ref,
        super(false);
  build() {
    return false;
  }

  Future<UserModel> getUser(){
    // final userId=_ref.watch(currentUserIdProvider);
    return _homeRepository.getUser(currentUserId);
  }

  updateUserdata(BuildContext context,UserModel userModel) async {
    final res = await _homeRepository.updateUserdata(uid: currentUserId, userModel: userModel);
    res.fold((l) => AppsHelper.showSnackBar(l.message,context), (r) {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile(),));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EditProfile(),));
    });
  }

  Stream<List<UserModel>> getUsers(String data){
    Map map=json.decode(data);
    return _homeRepository.getUsers(map["search"]);
  }
//   Stream getUsers(search) {
//     return _homeRepository.getUsers(search);
//   }
  addChats({required ChatModel chatmodel})async{
    await _homeRepository.addChats(chatmodel: chatmodel);
  }

  addReply({required String uId,required ChatModel chatModel,required BuildContext context }) async {
    await _homeRepository.addReply(uId, chatModel);

  }

  Stream<List<ChatModel>> getMessages(){
    return _homeRepository.getMessages();
  }

  void deleteMsg({required BuildContext context,required String docId}) {
    _homeRepository.deleteMsg(docId).then((_) {
      AppsHelper.showSnackBar('Message deleted', context);
      Navigator.pop(context);
    }).catchError((e) {
      AppsHelper.showSnackBar('Error deleting message: $e', context);
    });
  }

  addPosts(BuildContext context, {required PostModel postmodel})async{
    final res=await _homeRepository.addPosts(postModel:postmodel);
    res.fold((l)=> AppsHelper.showSnackBar(l.toString(), context),(r){
      AppsHelper.showSnackBar("Shared post successfully", context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen(),), (route) => false,);
    });
  }

  Stream<List<PostModel>> getPosts(){
    return _homeRepository.getPosts();
  }

  Future updatePost(String url) async {
    try {
      final post =await FirebaseFirestore.instance.collection("post").where("uId",isEqualTo: currentUserId).get();
      for(var doc in post.docs ){
        await FirebaseFirestore.instance.collection("post").doc(doc.id).update({
          "userProfile":url.isNotEmpty? url:currentUser?.profile,
        });
      }
    } catch (e) {
      return left(e.toString());
    }
  }
  Future userDataPost(String userName,String name,String userBio ) async {
    try {
      final userPost =await FirebaseFirestore.instance.collection("post").where("uId",isEqualTo: currentUserId).get();
      for(var doc in userPost.docs ){
        await FirebaseFirestore.instance.collection("post").doc(doc.id).update({
          "userName":userName.isNotEmpty? userName:currentUser?.userName,
          "name":name.isNotEmpty? name:currentUser?.name,
          "userBio":userBio.isNotEmpty? userBio:currentUser?.bio,
        });
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future updateStory(String url) async {
    try {
      final story =await FirebaseFirestore.instance.collection("stories").where("uId",isEqualTo: currentUserId).get();
      for(var doc in story.docs ){
        await FirebaseFirestore.instance.collection("stories").doc(doc.id).update({
          "userProfile":url.isNotEmpty? url:currentUser?.profile,
        });
      }
    } catch (e) {
      return left(e.toString());
    }
  }
  Future userDataStory(String userName) async {
    try {
      final story =await FirebaseFirestore.instance.collection("stories").where("uId",isEqualTo: currentUserId).get();
      for(var doc in story.docs ){
        await FirebaseFirestore.instance.collection("stories").doc(doc.id).update({
          "userName":userName.isNotEmpty? userName:currentUser?.userName
        });
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future updateComment(String url) async {
    try {
      final  postsSnapshot =await FirebaseFirestore.instance.collection("post").get();
      for (var postDoc in postsSnapshot.docs) {
        final commentSnapshot = await FirebaseFirestore.instance
            .collection("post")
            .doc(
            postDoc.id) // Use the post ID to access the comments subcollection
            .collection("comments")
            .where("userId", isEqualTo: currentUserId)
            .get();
      }
      for (var postDoc in postsSnapshot.docs) {
        final commentSnapshot = await FirebaseFirestore.instance
            .collection("post")
            .doc(postDoc.id) // Use the post ID to access the comments subcollection
            .collection("comments")
            .where("userId", isEqualTo: currentUserId)
            .get();
        for (var commentDoc in commentSnapshot.docs) {
          await FirebaseFirestore.instance
              .collection("post")
              .doc(postDoc.id)  // Post ID
              .collection("comments")
              .doc(commentDoc.id)  // Comment ID
              .update({
                "userProfile": url.isNotEmpty? url:currentUser?.profile
              });  // Update the userName field

          print("Updated userName in comment ID: ${commentDoc.id}");
        }
      }
    } catch (e) {
      return left(e.toString());
    }
  }
  Future userDateComment(String userName) async {
    try {
      final  postsSnapshot =await FirebaseFirestore.instance.collection("post").get();
      for (var postDoc in postsSnapshot.docs) {
        final commentSnapshot = await FirebaseFirestore.instance
            .collection("post")
            .doc(
            postDoc.id)
            .collection("comments")
            .where("userId", isEqualTo: currentUserId)
            .get();
      }
      for (var postDoc in postsSnapshot.docs) {
        final commentSnapshot = await FirebaseFirestore.instance
            .collection("post")
            .doc(postDoc.id)
            .collection("comments")
            .where("userId", isEqualTo: currentUserId)
            .get();
        for (var commentDoc in commentSnapshot.docs) {
          await FirebaseFirestore.instance
              .collection("post")
              .doc(postDoc.id)
              .collection("comments")
              .doc(commentDoc.id)
              .update({
                "userName": userName.isNotEmpty? userName:currentUser?.profile
              });

          print("Updated userName in comment ID: ${commentDoc.id}");
        }
      }
    } catch (e) {
      return left(e.toString());
    }
  }



  void deletePost({
    required BuildContext context,
    required String docId,
  }) {
    _homeRepository.deletePost(docId).then((_) {
      AppsHelper.showSnackBar('Post deleted successfully', context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen(selectedIndex: 3,),), (route) => false,);
    }).catchError((e,s) {
      print(e);
      print(s);
      AppsHelper.showSnackBar('Error deleting post: $e', context);
    });
  }


  uploadStories(BuildContext context,{required StoryModel storymodel})async{
    final res=await _homeRepository.uploadStories(storyModel: storymodel);
    res.fold((l)=> AppsHelper.showSnackBar(l.toString(), context),(r){
      AppsHelper.showSnackBar("Story added", context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen(selectedIndex: 0,),), (route) => false,);
    });
  }
  Stream<List<StoryModel>> getStories(){
    return _homeRepository.getStories();
  }

  Stream<List<StoryModel>> getYourStory(){
    return _homeRepository.getYourStory();
  }

  void deleteStory({
    required BuildContext context,
    required String docId,
  }) {
    _homeRepository.deleteStory(docId).then((_) {
      AppsHelper.showSnackBar('Your story deleted', context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen(selectedIndex: 0,),), (route) => false,);
    }).catchError((e,s) {
      print(e);
      print(s);
      AppsHelper.showSnackBar('Error deleting story: $e', context);
    });
  }


  addComments(String pId,{required CommentModel commentModel,
  })async{
    await _homeRepository.addComments(commentModel: commentModel,pId);
  }
  Stream<List<CommentModel>> getComments(){
    return _homeRepository.getComments();
  }

  Future<UserModel> getfollowUSer({required String uId}){
    return _homeRepository.getUser(uId);
  }

  void deleteComment({required BuildContext context,required String pId,required String cId}) {
    _homeRepository.deleteComment(cId,pId).then((_) {
      AppsHelper.showSnackBar('Comment deleted', context);
      Navigator.pop(context);
    }).catchError((e) {
      AppsHelper.showSnackBar('Error deleting comment: $e', context);
    });
  }


  Stream<List<PostModel>> likedPost() {
    return _homeRepository.likedPost();
  }
  Stream<List<CommentModel>> yourComments(){
    return _homeRepository.yourComments();
  }

}