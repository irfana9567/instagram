import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../common/providers/firebase_providers.dart';
import '../../../model/user_model.dart';

final AuthRepositoryProvider=Provider((ref) => AuthRepository(firestore: ref.watch(fireStoreProvider), firebaseAuth: FirebaseAuth.instance, ));

// final currentUserIdProvider = StateProvider((ref) => "");
class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth}) : _firestore=firestore, _firebaseAuth=firebaseAuth ;

  ///create user
  createUser({required UserModel userModel}) {
    try{
      DocumentReference reference=_firestore.collection("users").doc();

      // print(reference.id);
      UserModel userModelData=userModel.copyWith(
          id: reference.id,
          reference: reference,
      );
      // print(usermodelData.id);
      createEmail(userModel.email, userModel.password);
      return Right(reference.set(userModelData.toMap()));
    } catch(e){
      return Left(e.toString());
    }
  }
  ///create user with email&password
  createEmail(email,password){
    _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }
  ///user login
   loginUser(String email,String password,)async{
    try{
      final result=await _firestore.collection("users")
     .where('email',isEqualTo: email)
     .get();
      print(result);
      if(result.docs.isEmpty){
       return "This user does not exist";
      }
      final currentUserDoc = result.docs.first;
      final userData = currentUserDoc.data();
      final storedPassword = userData['password'];

      if (storedPassword == password) {
        currentUser = UserModel.fromMap(userData);
        currentUserId=currentUserDoc.id;
        return right(currentUser);
      } else {
        return left(('Incorrect password'));
      }
    }catch(e,s){
      print(s);
      return left(('Login failed'));
    }
  }


//   class AuthProvider with ChangeNotifier {
//   UserModel? currentUser;
//   String currentUserId = '';
//
//   Future<Either<String, UserModel>> loginUser(String email, String password) async {
//     try {
//       final result = await _firestore.collection("users")
//           .where('email', isEqualTo: email)
//           .get();
//
//       if (result.docs.isEmpty) {
//         return left("This user does not exist");
//       }
//
//       final currentUserDoc = result.docs.first;
//       final userData = currentUserDoc.data();
//       final storedPassword = userData['password'];
//
//       if (storedPassword == password) {
//         currentUser = UserModel.fromMap(userData);
//         currentUserId = currentUserDoc.id;
//         notifyListeners(); // Notify listeners about the state change
//         return right(currentUser!);
//       } else {
//         return left('Incorrect password');
//       }
//     } catch (e, s) {
//       print(s);
//       return left('Login failed');
//     }
//   }
// }






}