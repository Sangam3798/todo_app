import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/constant/strings.dart';
import 'package:todo/login/data/model/user_model.dart';
import 'package:todo/services/firebase_service.dart';
import 'package:todo/services/local_storage_service.dart';

class LoginController with ChangeNotifier {
  bool isLoading = false;

  Future<void> googleSignInCall() async {
    isLoading = true;
    notifyListeners();
    UserCredential? userData = await FirebaseService.instance.googleAuth();
    await LocalStorage.setValue(AppStrings.userIdKey, userData?.user?.uid ?? '');
    await FirebaseService.instance.storeDataToFireStore(
        data: UserModel(
                userId: userData?.user?.uid ?? '',
                fullName: userData?.user?.displayName ?? '',
                email: userData?.user?.email ?? '',
                profilePic: userData?.user?.photoURL ?? '')
            .toJson(),
        isUserData: true);
    isLoading = false;
    notifyListeners();
  }
}
