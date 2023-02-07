import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Profile extends StatelessWidget {

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
                SizedBox(height: 100.0,),
                Text("${auth.currentUser?.phoneNumber.toString()}"),
                SizedBox(height: 10.0,),
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
}
