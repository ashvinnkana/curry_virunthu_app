import 'dart:async';
import 'dart:io';
import 'package:curry_virunthu_app/screens/main_screen.dart';
import 'package:curry_virunthu_app/screens/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  final String phoneNum;

  Register(this.phoneNum);

  @override
  _RegisterState createState() => _RegisterState(this.phoneNum);
}

class _RegisterState extends State<Register> {
  bool loading = false;
  final String phoneNum;

  TextEditingController _controller = TextEditingController();
  TextEditingController fname_controller = TextEditingController();
  TextEditingController lname_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();

  _RegisterState(this.phoneNum) {
    _controller.text = this.phoneNum;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      ImageSlideshow(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 4,
                        initialPage: 0,
                        indicatorColor: Colors.blue,
                        indicatorBackgroundColor: Colors.grey,
                        onPageChanged: (value) {},
                        autoPlayInterval: 4000,
                        isLoop: true,
                        children: [
                          Image.asset('assets/bg/bg7.png', fit: BoxFit.cover),
                          Image.asset('assets/bg/bg1.jpg', fit: BoxFit.cover),
                          Image.asset('assets/bg/bg2.jpg', fit: BoxFit.cover),
                          Image.asset('assets/bg/bg3.jpg', fit: BoxFit.cover),
                          Image.asset('assets/bg/bg4.jpg', fit: BoxFit.cover),
                          Image.asset('assets/bg/bg6.jpg', fit: BoxFit.cover),
                        ],
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [
                              0.2,
                              0.7
                            ],
                                colors: [
                              Color.fromARGB(0, 10, 10, 10),
                              Color.fromARGB(200, 10, 10, 10),
                            ])),
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Positioned(
                          bottom: 50,
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(1),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: const Center(
                                child: Text(
                                  "W E L C O M E   T O",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )),
                      Positioned(
                          bottom: 20,
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(1),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: const Center(
                                child: Text(
                                  "C U R R Y   V I R U N D H U",
                                  style: TextStyle(
                                    color: Colors.lightGreenAccent,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [
                            0.2,
                            0.7
                          ],
                              colors: [
                            Color.fromRGBO(127, 180, 15, 0.5),
                            Color.fromRGBO(127, 180, 15, 0.5),
                          ])),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                _emoji(),
                                style: const TextStyle(fontSize: 25),
                              ),
                              const Text(
                                "  +61     ",
                                style: TextStyle(fontSize: 15),
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width/2,
                                  child: TextField(
                                    enabled: false,
                                    controller: _controller,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Phone Number",
                                      hintText: "41 655 1457",
                                    ),
                                    onChanged: (text) => setState(() {}),
                                  ))
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text(
                      textAlign: TextAlign.right,
                      "Phone Number Verified!",
                      style: TextStyle(
                          fontSize: 11,
                          color: Color.fromRGBO(127, 180, 15, 1.0)),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Divider(color: Colors.white),
                  const SizedBox(height: 10.0),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text(
                      "Looks like we have a new friend, let us know more about yourself",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [
                                0.2,
                                0.7
                              ],
                                  colors: [
                                Color.fromARGB(255, 40, 40, 40),
                                Color.fromARGB(255, 40, 40, 40),
                              ])),
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: TextField(
                                controller: fname_controller,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "First Name",
                                ),
                                onChanged: (text){
                                  setState(() {

                                  });
                                },
                              )),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [
                                0.2,
                                0.7
                              ],
                                  colors: [
                                Color.fromARGB(255, 40, 40, 40),
                                Color.fromARGB(255, 40, 40, 40),
                              ])),
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: TextField(
                                controller: lname_controller,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Last Name",
                                ),
                                onChanged: (text){
                                  setState(() {

                                  });
                                },
                              )),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [
                              0.2,
                              0.7
                            ],
                                colors: [
                              Color.fromARGB(255, 40, 40, 40),
                              Color.fromARGB(255, 40, 40, 40),
                            ])),
                        child: Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: TextField(
                              controller: email_controller,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Email Address",
                              ),
                              onChanged: (text){
                                setState(() {

                                });
                              },
                            )),
                      )),
                  const SizedBox(height: 5.0),
                  EmailValidator.validate(email_controller.text) == false &&
                          email_controller.text != ""
                      ? const Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Text(
                            textAlign: TextAlign.right,
                            "Invalid Email!",
                            style: TextStyle(
                                fontSize: 11,
                                color: Color.fromRGBO(231, 75, 75, 1.0)),
                          ),
                        )
                      : SizedBox(),
                  const SizedBox(height: 20.0),
                  Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: fname_controller.text == "" ||
                              lname_controller.text == "" ||
                              email_controller.text == "" ||
                              EmailValidator.validate(email_controller.text) ==
                                  false
                          ? ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.grey.shade800,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onPressed: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Cannot Proceed'),
                                      content:
                                          const Text('All Fields Required!'),
                                      actions: <Widget>[
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          child: const Text('Okay'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.block,
                                size: 24.0,
                              ),
                              label: const Text("SAVE AND CONTINUE"))
                          : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.lightGreen.shade800,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onPressed: () {
                                setState(() {
                                  loading = true;
                                });
                                FirebaseFirestore.instance
                                    .collection('customer')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .set({
                                      'fname': fname_controller.text,
                                      'lname': lname_controller.text,
                                      'email': email_controller.text,
                                      'dineInCart': [],
                                      'mobile': "+61$phoneNum"
                                    })
                                    .then((value) => {
                                          print(
                                              "NEW USER REGISTERED SUCCESSFULLY"),
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return MainScreen(0, "All");
                                              },
                                            ),
                                          )
                                        })
                                    .catchError((onError) => {
                                          showDialog<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Something went Wrong!'),
                                                content:
                                                    Text(onError.toString()),
                                                actions: <Widget>[
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelLarge,
                                                    ),
                                                    child: const Text('Okay'),
                                                    onPressed: () {
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          )
                                        });
                              },
                              icon: Icon(
                                Icons.save,
                                size: 24.0,
                              ),
                              label: const Text("SAVE AND CONTINUE"))),
                ],
              ),
              getLoadingScreen()
            ],
          ),
        ));
  }

  getLoadingScreen() {
    if (loading) {
      return Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.4, 0.7],
                colors: [
                  Color.fromARGB(180, 0, 0, 0),
                  Color.fromARGB(180, 27, 54, 3),

                ],
                // stops: [0.0, 0.1],
              ),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
              bottom: 80,
              left: MediaQuery.of(context).size.width / 4,
              child: Image.asset(
                "assets/loading.gif",
                width: MediaQuery.of(context).size.width / 2,
              )),
          Positioned(
              bottom: 50,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "R E G I S T E R I N G   U S E R\n. . .",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )))
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  String _emoji() {
    int flagOffset = 0x1F1E6;
    int asciiOffset = 0x41;

    String country = "AU";

    int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
    int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;

    String emoji =
        String.fromCharCode(firstChar) + String.fromCharCode(secondChar);

    return emoji;
  }
}
