import 'package:curry_virunthu_app/util/temp.dart';
import 'package:curry_virunthu_app/util/user_session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../widgets/gradient_slide_to_act.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_screen.dart';

class CardForm extends StatefulWidget {
  CardForm({Key? key}) : super(key: key);

  @override
  _CardFormState createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(2, "All")));
            },
          ),
          elevation: 0.0,
          title: Text("Pay with a Credit Card"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 123, 152, 60),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Card Form',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CardFormField(
                    controller: CardFormEditController(),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Pay'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreen.shade800,
                    ),
                  )
                ],
              ),
            ),
            getLoadingScreen()
          ],
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
              top: 10,
              left: MediaQuery.of(context).size.width / 4,
              child: Image.asset(
                "assets/loading.gif",
                width: MediaQuery.of(context).size.width / 2,
              )),
          Positioned(
              top: 160,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "C O N F I R M I N G   O R D E R\n. . .",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )))
        ],
      );
    } else {
      return Container();
    }
  }
}
