// ignore_for_file: prefer_const_constructors

import 'package:app_practice/FirebaseAuth/dialog_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'FirebaseAuth/auth.dart';
import 'Pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize Firebase

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCRnMs5hPGXiRC1u4VHPfB6g8vQWCAFCko",
      authDomain: "flutter-web-l.firebaseapp.com",
      projectId: "flutter-web-l",
      storageBucket: "flutter-web-l.appspot.com",
      messagingSenderId: "659217607239",
      appId: "1:659217607239:web:551ea9697b7444ad20df62"
    )
  );
  runApp(MyApp());
}

// Modify MyApp to a Stateful Widget
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // To define a method called getUserInfo to invoke getUser function
  Future getUserInfo() async {
    await getUser();
    setState(() {});
    print(uid);
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ChoreNoMore",
      theme: ThemeData(brightness: Brightness.light),
      home: HomePage(),
    );
  }
}