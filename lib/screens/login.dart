import 'dart:async';
import 'dart:io';
import 'package:curry_virunthu_app/screens/main_screen.dart';
import 'package:curry_virunthu_app/screens/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controller = TextEditingController();
  bool loading = false;



  @override
  Widget build(BuildContext context) {

    if(FirebaseAuth.instance.currentUser?.phoneNumber == null){
      print("Logged Out");
      return WillPopScope(
          onWillPop: () async {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Alert!'),
                  content: const Text('Do you want to continue to exit the app?'),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Yes'),
                      onPressed: () {
                        exit(0);
                      },
                    ),
                  ],
                );
              },
            );
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
                          height: MediaQuery.of(context).size.height / 1.8,
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
                          height: MediaQuery.of(context).size.height / 1.8,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Positioned(
                            bottom: 80,
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
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )),
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
                    const SizedBox(height: 50.0),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        "Proceed to explore a delicious Indian and Sri Lankan Cuisine",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
                                  Color.fromARGB(255, 40, 40, 40),
                                  Color.fromARGB(255, 40, 40, 40),
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
                                    width: 200,
                                    child: TextField(
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
                    const SizedBox(height: 10.0),
                    Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: (_controller.text.length > 9 ||
                            _controller.text.length < 9) &&
                            _controller.text.isNotEmpty
                            ? const Text(
                          "Valid Phone Number Required!",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color.fromARGB(255, 203, 26, 26)),
                        )
                            : Text("")),
                    const SizedBox(height: 20.0),
                    Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Center(
                            child: SizedBox(
                                width: 400,
                                height: 52,
                                child: _controller.text == "" ||
                                    _controller.text.length > 9 ||
                                    _controller.text.length < 9
                                    ? ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.grey.shade800,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10))),
                                    onPressed: () {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Cannot Proceed'),
                                            content: const Text(
                                                'Valid phone number is required!'),
                                            actions: <Widget>[
                                              TextButton(
                                                style:
                                                TextButton.styleFrom(
                                                  textStyle:
                                                  Theme.of(context)
                                                      .textTheme
                                                      .labelLarge,
                                                ),
                                                child: const Text('Okay'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop();
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
                                    label: const Text("G E T   S T A R T E D")) :
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.lightGreen.shade800,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10))),
                                    onPressed: ()  async {
                                      setState(() {
                                        loading = true;
                                      });

                                      FirebaseAuth auth = FirebaseAuth.instance;
                                      print('+61${_controller.text}');

                                      try {
                                        var status = false;
                                        await auth.verifyPhoneNumber(
                                          phoneNumber: '+61${_controller.text}',
                                          timeout: const Duration(seconds: 60),
                                          verificationCompleted:
                                              (PhoneAuthCredential
                                          credential) async {
                                            await FirebaseAuth.instance
                                                .signInWithCredential(credential)
                                                .then((value) => {
                                              status = true,
                                              FirebaseFirestore.instance
                                                  .collection('customer')
                                                  .where("mobile", isEqualTo: "+61${_controller.text}").get()
                                                  .then((QuerySnapshot querySnapshot) {
                                                querySnapshot.docs.forEach((doc) {
                                                  print("hi");
                                                });
                                              })
                                            })
                                                .catchError((onError) => {
                                              status = true,
                                              setState(() {
                                                loading = false;
                                                _controller =
                                                new TextEditingController();
                                              }),
                                              showDialog<void>(
                                                context: context,
                                                builder: (BuildContext
                                                context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Something Went Wrong'),
                                                    content: const Text(
                                                        'Invalid OTP, Login Failed'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          textStyle: Theme.of(
                                                              context)
                                                              .textTheme
                                                              .labelLarge,
                                                        ),
                                                        child: const Text(
                                                            'Okay'),
                                                        onPressed: () {
                                                          Navigator.of(
                                                              context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              )
                                            });
                                          },
                                          verificationFailed:
                                              (FirebaseAuthException e) {
                                            print("Phone ERROR: " +
                                                e.message.toString());
                                            status = true;
                                            setState(() {
                                              loading = false;
                                              _controller =
                                              new TextEditingController();
                                            });
                                            showDialog<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Something Went Wrong'),
                                                  content: Text(
                                                      e.message.toString()),
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          codeSent: (String verificationId,
                                              int? resendToken) {
                                            status = true;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) {
                                                  return Otp(verificationId, _controller.text);
                                                },
                                              ),
                                            );
                                          },
                                          codeAutoRetrievalTimeout:
                                              (String verificationId) {},
                                        );

                                        final timer = Timer(
                                          const Duration(seconds: 15),
                                              () {
                                            print(ModalRoute.of(context)
                                                ?.settings
                                                .name);
                                            if (ModalRoute.of(context)
                                                ?.settings
                                                .name ==
                                                null &&
                                                status == false) {
                                              setState(() {
                                                loading = false;
                                                _controller =
                                                new TextEditingController();
                                              });
                                              showDialog<void>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Something Went Wrong'),
                                                    content: const Text(
                                                        'Entered phone number was attempted already, cannot send verification code immediately\n\nTRY AGAIN LATER'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        style:
                                                        TextButton.styleFrom(
                                                          textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelLarge,
                                                        ),
                                                        child: const Text('Okay'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        );
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Text("G E T   S T A R T E D"))
                            )
                        )
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
                getLoadingScreen()
              ],
            ),
          ));
    } else {
      print("Logged in ${FirebaseAuth.instance.currentUser?.phoneNumber}");

      return MainScreen(0, "All");

    }


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
                stops: [0.2, 0.5],
                colors: [
                  Color.fromARGB(180, 27, 54, 3),
                  Color.fromARGB(180, 0, 0, 0),
                ],
                // stops: [0.0, 0.1],
              ),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
              top: 60,
              left: MediaQuery.of(context).size.width / 4,
              child: Image.asset(
                "assets/loading.gif",
                width: MediaQuery.of(context).size.width / 2,
              )),
          Positioned(
              top: 210,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                  child: Text(
                "S E N D I N G   C O D E\n. . .",
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
