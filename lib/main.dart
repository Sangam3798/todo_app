import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/constant/strings.dart';
import 'package:todo/home/controller/home_controller.dart';
import 'package:todo/home/view/home_view.dart';
import 'package:todo/services/firebase_service.dart';
import 'package:todo/login/controller/login_controller.dart';
import 'package:todo/login/view/login_view.dart';
import 'package:todo/services/local_storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseService.instance.initialiseFirebase().then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> localStorageCall;
  late Widget homeView;
  late Widget loginView;

  @override
  void initState() {
    localStorageCall = LocalStorage.getValue(AppStrings.userIdKey);
    homeView = ChangeNotifierProvider(create: (_) => HomeController(), child:  HomeView());
    loginView = ChangeNotifierProvider(create: (_) => LoginController(), child: const LoginView());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<String>(
          future: localStorageCall,
          builder: (context, snapshot) {
            log('call for future ');
            return snapshot.hasData
                ? snapshot.data != null && snapshot.data!.isNotEmpty
                    ? homeView
                    : loginView
                : Center(
                    child: Transform.scale(
                    scale: 0.5,
                    child: const CircularProgressIndicator(),
                  ));
          }),
    );
  }
}
