import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Profile extends StatelessWidget {

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
