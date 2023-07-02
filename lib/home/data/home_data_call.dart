import 'package:todo/login/data/model/user_model.dart';
import 'package:todo/services/firebase_service.dart';

class HomeDataCall {
  HomeDataCall._();

  static HomeDataCall instance = HomeDataCall._();

  Future<UserModel?> getUserData() async {
    Map<String, dynamic>? response = await FirebaseService.instance.getDataFromFireStore(isUserData: true);
    return response != null ? UserModel.fromJson(response) : null;
  }
}
