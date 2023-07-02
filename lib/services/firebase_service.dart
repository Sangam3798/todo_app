import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/constant/strings.dart';
import 'package:todo/login/data/model/todo_model.dart';
import 'package:todo/services/local_storage_service.dart';

class FirebaseService {
  FirebaseService._();

  static FirebaseService instance = FirebaseService._();

  Future<void> initialiseFirebase() async {
    await Firebase.initializeApp();
  }

  Future<UserCredential?> googleAuth() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final cred = await FirebaseAuth.instance.signInWithCredential(credential);
      return cred;
    } catch (e) {
      log('exception in google auth $e');
      return null;
    }
  }
  Future<bool>authSignOut()async{
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      return true;
    }catch(e){
      log('exception while logout $e');
      return false;
    }
  }

  Future<bool> storeDataToFireStore({bool isUserData = false, String? todoId, required Map<String, dynamic> data}) async {
    try {
      DocumentReference documentReference;
      String userId = await LocalStorage.getValue(AppStrings.userIdKey);
      if (isUserData) {
        documentReference = FirebaseFirestore.instance.collection('Users').doc(userId);
      } else {
        documentReference = FirebaseFirestore.instance.collection('todos').doc(userId).collection('todo$userId').doc(todoId);
      }
      await documentReference.set(data);
      return true;
    } catch (e) {
      log("Exception while writing data to fireStore $e");
      return false;
    }
  }

  Future<dynamic> getDataFromFireStore({bool isUserData = false, String? todoId}) async {
    try {
      String userId = await LocalStorage.getValue(AppStrings.userIdKey);
      if (isUserData) {
        DocumentReference documentReference = FirebaseFirestore.instance.collection('Users').doc(userId);
        DocumentSnapshot<Object?> documentSnapshot = await documentReference.get();
        Map<String, dynamic>? response = documentSnapshot.data() as Map<String, dynamic>;
        return response;
      } else {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance.collection('todos').doc(userId).collection('todo$userId').get();
        return querySnapshot.docs.map((doc) => TodoModel.fromJson(doc.data())).toList();
      }
    } catch (e) {
      log("Exception while reading data to fireStore $e");
      return null;
    }
  }

  Future<bool> updateDataToFireStore({bool isUserData = false, String? todoId, required Map<String, dynamic> data}) async {
    try {
      DocumentReference documentReference;
      String userId = await LocalStorage.getValue(AppStrings.userIdKey);
      if (isUserData) {
        documentReference = FirebaseFirestore.instance.collection('Users').doc(userId);
      } else {
        documentReference = FirebaseFirestore.instance.collection('todos').doc(userId).collection('todo$userId').doc(todoId);
      }
      await documentReference.update(data);
      return true;
    } catch (e) {
      log("Exception while updating data to fireStore $e");
      return false;
    }
  }

  Future<bool> deleteDataFromFireStore({bool isUserData = false, String? todoId}) async {
    try {
      DocumentReference documentReference;
      String userId = await LocalStorage.getValue(AppStrings.userIdKey);
      if (isUserData) {
        documentReference = FirebaseFirestore.instance.collection('Users').doc(userId);
      } else {
        documentReference = FirebaseFirestore.instance.collection('todos').doc(userId).collection('todo$userId').doc(todoId);
      }
      await documentReference.delete();
      return true;
    } catch (e) {
      log("Exception while deleting data to fireStore $e");
      return false;
    }
  }
}
