import 'package:flutter/material.dart';

class Cart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(

        child: Image.asset(
          "assets/empty_cart.png",
          height: MediaQuery.of(context).size.height/3,
          width: MediaQuery.of(context).size.height/3,
        ),
      ),
    );
  }
}
