import 'dart:async';
import 'package:flutter/material.dart';

class AddToCart extends StatefulWidget {
  const AddToCart({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pop(context));

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const SizedBox(height: 100.0),
              Image.asset(
                "assets/added-to-cart.gif",
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.height / 2,
                fit: BoxFit.cover,
              ),
              const Text(
                "ADDED TO CART",
                style: TextStyle(fontSize: 30),
              ),
              const Text(
                "SUCCESSFULLY",
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 55, 201, 148)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
