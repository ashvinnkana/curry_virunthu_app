import 'dart:async';

import 'package:curry_virunthu_app/screens/main_screen.dart';
import 'package:flutter/material.dart';

class AddToCart extends StatefulWidget {
  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {


  @override
  Widget build(BuildContext context) {

    Timer(
        Duration(seconds: 2),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => MainScreen())));

    return Stack (
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const SizedBox(height: 100.0),
              Stack(
                children: <Widget>[
                  Image.asset(
                    "assets/addeed-to-cart.gif",
                    height: MediaQuery.of(context).size.height/2,
                    width: MediaQuery.of(context).size.height/2,
                    fit: BoxFit.cover,
                  ),
                  Positioned(

                    bottom: 70,
                    left: 80,
                      child: Text(
                        "ADDED TO CART",
                        style: TextStyle(
                          fontSize: 30
                        ),
                      ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 120,
                    child: Text(
                      "SUCCESSFULLY",
                      style: TextStyle(
                          fontSize: 20,
                        color: Color.fromARGB(255, 55, 201, 148)
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
      )
    ],
    );
  }
}
