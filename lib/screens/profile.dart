import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Profile extends StatelessWidget {

  TextEditingController _controller = TextEditingController();
  TextEditingController fname_controller = TextEditingController();
  TextEditingController lname_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();

  Profile() {
    FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser?.uid)
    .get()
    .then((value) => {
      print(value["fname"]),
        _controller.text = value["mobile"].replaceAll("+61",""),
        fname_controller.text = value["fname"],
        lname_controller.text = value["lname"],
        email_controller.text = value["email"],
    });

  }

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title:
        const Text("M Y  P R O F I L E", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 123, 152, 60),
      ),
      body:Container(
        child: Center(
            child: Column(
              children: [
                SizedBox(height: 50.0,),
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
                                  enabled: false,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: "Phone Number",
                                    hintText: "41 655 1457",
                                  ),
                                ))
                          ],
                        )),
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
                              enabled: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "First Name",
                              ),
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
                              enabled: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Last Name",
                              ),
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
                            enabled: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Email Address",
                            ),
                            onChanged: (text) {},
                          )),
                    )),
                SizedBox(height: 20.0,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 243, 109, 109),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {

                            return Login();
                          },
                        ),
                      );
                    },
                    child: Text("LOGOUT")),
              ],
            )
        ),
      )
    );


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
