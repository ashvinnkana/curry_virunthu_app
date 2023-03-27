import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curry_virunthu_app/util/temp.dart';
import 'package:curry_virunthu_app/util/user_session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:curry_virunthu_app/util/const.dart';
import 'package:curry_virunthu_app/screens/login.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '.env';

Future<void> _firebaseMessagingBackgroundHandler(message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('Internet Connection Successfull!');
    }
  } on SocketException catch (_) {
  }


}

class MyApp extends StatefulWidget {
  MyApp() {
    print("=> SETTING UP USER SESSION");
    Session.userData = null;
    if (FirebaseAuth.instance.currentUser?.phoneNumber != null) {
      FirebaseFirestore.instance
          .collection('customer')
          .where("mobile",
          isEqualTo: "${FirebaseAuth.instance.currentUser?.phoneNumber}").get()
          .then((QuerySnapshot querySnapshot) {
        print("Query: ${querySnapshot.docs.length}");
        if (querySnapshot.docs.isEmpty) {
          Session.userData = null;
          FirebaseAuth.instance.signOut();
          Fluttertoast.showToast(
              msg: "Earlier Registration was incomplete, Retry!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.lightGreenAccent,
              textColor: Colors.black,
              fontSize: 16.0);
        } else {
          Session.userData = querySnapshot.docs[0];
        }
      });
    }
  }

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
