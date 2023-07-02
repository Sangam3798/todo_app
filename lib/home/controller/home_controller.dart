import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/constant/strings.dart';
import 'package:todo/home/data/home_data_call.dart';
import 'package:todo/login/controller/login_controller.dart';
import 'package:todo/login/data/model/todo_model.dart';
import 'package:todo/login/data/model/user_model.dart';
import 'package:todo/login/view/login_view.dart';
import 'package:todo/services/firebase_service.dart';
import 'package:todo/services/local_storage_service.dart';

class HomeController with ChangeNotifier {
  bool addTodoLoader = false;
  UserModel? userDataValue;
  String taskName = '';
  String taskDescription = '';
  String taskDate = '';
  List<TodoModel>? todos;

  HomeController() {
    getUserData();
  }

  Future<void> getUserData() async {
    log('api call');
    addTodoLoader = true;
    notifyListeners();
    UserModel? userModel = await HomeDataCall.instance.getUserData();
    userDataValue = userModel;
    await getTodos();
    addTodoLoader = false;
    notifyListeners();
  }

  Future<void> addTodo() async {
    addTodoLoader = true;
    notifyListeners();
    String todoId = DateTime.now().millisecondsSinceEpoch.toString();
    String userId = await LocalStorage.getValue(AppStrings.userIdKey);
    await FirebaseService.instance.storeDataToFireStore(
        data: TodoModel(
                todoId: todoId, taskName: taskName, description: taskDescription, date: taskDate, isMark: false, userId: userId)
            .toJson(),
        todoId: todoId);
    await getTodos();
    addTodoLoader = false;
    notifyListeners();
  }

  Future<void>getTodos()async{
    List<TodoModel>? response  = await FirebaseService.instance.getDataFromFireStore();
    if(response != null){
      todos = response;
    }
    log('response ${response?.first.taskName}');
  }

  Future<void>deleteTodo(String todoId)async{
    await FirebaseService.instance.deleteDataFromFireStore(todoId: todoId);
    await getTodos();
    notifyListeners();
  }

  Future<void>updateTodo(TodoModel? todoModel)async{
    await FirebaseService.instance.updateDataToFireStore(data: todoModel?.toJson() ?? {},todoId: todoModel?.todoId);
    await getTodos();
    notifyListeners();
  }

  Future<void>updateTodoLoader(TodoModel? todoModel)async{
    addTodoLoader = true;
    notifyListeners();
    await FirebaseService.instance.updateDataToFireStore(data: todoModel?.toJson() ?? {},todoId: todoModel?.todoId);
    await getTodos();
    addTodoLoader = false;
    notifyListeners();
  }

  Future<void>logout(BuildContext context)async{
    addTodoLoader = true;
    notifyListeners();
    await FirebaseService.instance.authSignOut();
    await LocalStorage.clearValue();
    addTodoLoader = false;
    notifyListeners();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => LoginController(),
          child: LoginView(),
        ),
      ),
    );
  }
}
