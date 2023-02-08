import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curry_virunthu_app/screens/otp.dart';
import 'package:curry_virunthu_app/util/temp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:curry_virunthu_app/util/const.dart';
import 'package:curry_virunthu_app/screens/main_screen.dart';
import 'package:curry_virunthu_app/screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('Internet Connection Successfull!');
    }
  } on SocketException catch (_) {
  }

  Temp.categoryLabels = ["All"];

  FirebaseFirestore.instance.collection('category')
      .orderBy("orderId")
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      Temp.categoryLabels.add(doc["label"].toString());
    });
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: Constants.darkTheme,
      darkTheme: Constants.darkTheme,
      //home: MainScreen(0),
      home: Login(),
    );
  }
}
