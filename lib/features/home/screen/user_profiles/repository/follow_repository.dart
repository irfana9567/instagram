import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/providers/firebase_providers.dart';

final followRepositoryProvider=Provider((ref) => FollowRepository(firestore: ref.watch(fireStoreProvider)),);

class FollowRepository {
  final FirebaseFirestore _firestore;

  //  DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();
  //
  //   if (userDoc.exists) {
  //     // Get user data such as name and profile
  //     Map<String, dynamic> userData = {
  //       'uid': uid,
  //       'name': userDoc['name'],
  //       'profile': userDoc['profile'],
  //     };

  FollowRepository({required FirebaseFirestore firestore}) :_firestore=firestore;

  // Follow user by adding their ID to the following list and the user's followers list
  Future<void> followUser(String currentUserId, String otherUserId) async {
    DocumentSnapshot snap=await _firestore.collection('users').doc(currentUserId).get();
    Map<String,dynamic> currentUserData={
      "uid":currentUserId,
       "name":snap["name"],
      "userName":snap["userName"],
      "profile":snap["profile"]
    };
    DocumentSnapshot snap2=await _firestore.collection('users').doc(otherUserId).get();
    Map<String,dynamic> othersUserData={
      "uid":otherUserId,
      "name":snap2["name"],
      "userName":snap2["userName"],
      "profile":snap2["profile"]
    };
    try {
      // Update current user (add the other user's ID to following)
      await _firestore.collection('users').doc(currentUserId).update({
        'following': FieldValue.arrayUnion([othersUserData])
      });

      // Update the other user (add the current user's ID to followers)
      await _firestore.collection('users').doc(otherUserId).update({
        'followers': FieldValue.arrayUnion([currentUserData])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Unfollow user by removing their ID from the following list and the user's followers list
  Future<void> unfollowUser(String currentUserId, String otherUserId) async {
    DocumentSnapshot snap=await _firestore.collection('users').doc(currentUserId).get();
    Map<String,dynamic> currentUserData={
      "uid":currentUserId,
      "name":snap["name"],
      "userName":snap["userName"],
      "profile":snap["profile"]
    };
    DocumentSnapshot snap2=await _firestore.collection('users').doc(otherUserId).get();
    Map<String,dynamic> othersUserData={
      "uid":otherUserId,
      "name":snap2["name"],
      "userName":snap2["userName"],
      "profile":snap2["profile"]
    };
    try {
      // Update current user (remove the other user's ID from following)
      await _firestore.collection('users').doc(currentUserId).update({
        'following': FieldValue.arrayRemove([othersUserData])
      });

      // Update the other user (remove the current user's ID from followers)
      await _firestore.collection('users').doc(otherUserId).update({
        'followers': FieldValue.arrayRemove([currentUserData])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Check if the current user is following the other user
  Future<bool> isFollowing(String currentUserId, String otherUserId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(currentUserId).get();
      if (doc.exists) {
        List following = doc.get('following') ?? []; // Use default empty list if 'following' is null
        return following.contains(otherUserId);
      }
      return false; // Return false if the document doesn't exist
    } catch (e) {
      print(e.toString()); // Handle the error properly
      return false;
    }
  }






}