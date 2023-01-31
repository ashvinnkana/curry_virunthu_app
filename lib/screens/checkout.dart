import 'package:curry_virunthu_app/util/user.dart';
import 'package:flutter/material.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:flutter/services.dart';
import '../widgets/gradient_slide_to_act.dart';
import 'add_to_cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main_screen.dart';

class Checkout extends StatefulWidget {
  final int total;

  Checkout(this.total);

  @override
  _CheckoutState createState() => _CheckoutState(total);
}

class _CheckoutState extends State<Checkout> {
  final int total;

  _CheckoutState(this.total);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(2)));
            },
          ),
          elevation: 0.0,
          title: Text("C H E C K O U T"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 123, 152, 60),
        ),
        body: Container());
  }
}
