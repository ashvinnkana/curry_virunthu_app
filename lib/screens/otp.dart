import 'dart:io';

import 'package:curry_virunthu_app/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../util/user_session.dart';
import 'login.dart';
import 'main_screen.dart';

class Otp extends StatefulWidget {
  final String verifyId;
  final String phoneNum;

  Otp(this.verifyId, this.phoneNum);

  @override
  _OtpState createState() => _OtpState(this.verifyId, this.phoneNum);
}

class _OtpState extends State<Otp> {
  final String verifyId;
  final String phoneNum;
  bool loading = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  _OtpState(this.verifyId, this.phoneNum);

  @override
  Widget build(BuildContext context) {
    bool _errorState = false;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(38, 128, 10, 1.0),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(241, 77, 77, 1.0),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(81, 189, 24, 1.0)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    var code = "";

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 25, right: 25),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/verify-phone.png',
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Phone Verification",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "We need to verify your phone before getting started!",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Pinput(
                        length: 6,
                        forceErrorState: _errorState,
                        errorText: 'Wrong Pin',
                        defaultPinTheme: defaultPinTheme,
                        errorPinTheme: errorPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsRetrieverApi,
                        showCursor: true,
                        onCompleted: (pin) async {
                          setState(() {
                            loading = true;
                          });
                          try {
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: this.verifyId,
                                    smsCode: pin);

                            // Sign the user in (or link) with the credential
                            await FirebaseAuth.instance
                                .signInWithCredential(credential)
                                .then((value) => {
                                      Session.userData = null,
                                      FirebaseFirestore.instance
                                          .collection('customer')
                                          .where("mobile",
                                              isEqualTo: "+61$phoneNum")
                                          .get()
                                          .then((QuerySnapshot querySnapshot) {
                                        if (querySnapshot.docs.isEmpty) {
                                          Session.userData = null;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return Register(phoneNum);
                                              },
                                            ),
                                          );
                                        } else {
                                          Session.userData =
                                              querySnapshot.docs[0];
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return MainScreen(0, "All");
                                              },
                                            ),
                                          );
                                        }
                                      })
                                    })
                                .catchError((onError) => {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Something Went Wrong'),
                                            content: const Text(
                                                'Invalid OTP, Login Failed'),
                                            actions: <Widget>[
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge,
                                                ),
                                                child: const Text('Okay'),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                          context) {
                                                        return Otp(
                                                            verifyId, phoneNum);
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    });
                          } catch (e) {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Something Went Wrong'),
                                  content: const Text(
                                      'Invalid OTP, Please Re-enter!'),
                                  actions: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: const Text('Okay'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return Otp(verifyId, phoneNum);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        onChanged: (value) {
                          code = value;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text("SMS sent to +61 ${phoneNum}"),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return Login();
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                "Edit Phone Number ?",
                                style: TextStyle(color: Colors.blue),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
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
                stops: [0.4, 0.9],
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
              bottom: 50,
              left: MediaQuery.of(context).size.width / 4,
              child: Image.asset(
                "assets/loading.gif",
                width: MediaQuery.of(context).size.width / 2,
              )),
          Positioned(
              bottom: 30,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "V E R I F Y I N G   P H O N E\n. . .",
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
}
