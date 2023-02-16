import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curry_virunthu_app/util/noti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:curry_virunthu_app/screens/my_order.dart';
import 'package:curry_virunthu_app/screens/cart.dart';
import 'package:curry_virunthu_app/screens/home.dart';
import 'package:curry_virunthu_app/screens/profile.dart';
import 'package:curry_virunthu_app/screens/today_menu.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../util/temp.dart';

class MainScreen extends StatefulWidget {
  final int page;
  final String subPage;

  MainScreen(this.page, this.subPage);

  @override
  _MainScreenState createState() => _MainScreenState(page, subPage);
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  late int _page;
  late String subPage;

  _MainScreenState(this._page, this.subPage);

  List icons = [
    Icons.home,
    Icons.label,
    Icons.shopping_cart,
    Icons.notifications,
    Icons.person,
  ];

  List pages = [
    Home(),
    Menu("All"),
    Cart(),
    MyOrder(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 0), () => {_pageController.jumpToPage(_page)});
    return WillPopScope(
        onWillPop: () async {
      return false;
    },
    child:Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: List.generate(5, (index){
          if (index == 1) {
            return Menu(subPage);
          }
          return pages[index];
        }),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // SizedBox(width: 7),
            buildTabIcon(0),
            buildTabIcon(1),
            buildTabIcon(3),
            buildTabIcon(4),
            // SizedBox(width: 7),
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: const Icon(
          Icons.shopping_cart,
        ),
        onPressed: () => _pageController.jumpToPage(2),
      ),
    )
    );
  }

  // void navigationTapped(int page) {
  //    _pageController.jumpToPage(page);
  //  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Noti.initialize(flutterLocalNotificationsPlugin);
    getToken();
    initInfo();
  }




  initInfo() {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      print("--------------ON MESSAGE------------------");
      print("onMessage: ${message.notification?.title}/${message.notification?.body}");


      // Noti.showBigTextNotification(title: message.notification?.title.toString(),
      //     body: message.notification?.title,
      //     fln: flutterLocalNotificationsPlugin);
      final snackBar = SnackBar(content: Text(message.notification?.title ?? ""));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);


    });
  }

  String? mtoken = " ";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("DeviceTokens").doc(FirebaseAuth.instance.currentUser?.uid)
        .set({'token': token});
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
      FirebaseFirestore.instance
          .collection("customer")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({"dineInCart": Temp.dine_in_cart})
          .then((value) => {
        print("Cart Updated")

      })
          .catchError((error) =>
          print("Failed to update cart: $error"));
    });


  }

  buildTabIcon(int index) {
    return Container(
      margin:
          EdgeInsets.fromLTRB(index == 3 ? 30 : 0, 0, index == 1 ? 30 : 0, 0),
      child: IconButton(
        icon: Icon(
          icons[index],
          size: 24.0,
        ),
        color: _page == index
            ? Theme.of(context).accentColor
            : Theme.of(context).textTheme.caption?.color,
        onPressed: () => _pageController.jumpToPage(index),
      ),
    );
  }
}
