import 'package:flutter/material.dart';
import 'package:curry_virunthu_app/util/const.dart';

class CartItem extends StatefulWidget {
  final String img;
  final int price;
  final String itemid;
  final List<Map<String, dynamic>> choices;

  CartItem({
    required this.img,
    required this.price,
    required this.itemid,
    required this.choices,
  });

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 10.0,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        // Add one stop for each color. Stops should increase from 0 to 1
                        stops: [0.2, 0.7],
                        colors: [
                          Color.fromARGB(242, 255, 0, 0),
                          Color.fromARGB(100, 52, 52, 52),
                        ],
                        // stops: [0.0, 0.1],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height / 7,
                    width: MediaQuery.of(context).size.width,
                    ),
                    ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      "${widget.img}",
                      height: MediaQuery.of(context).size.height / 7,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
              ]
              ),
              const SizedBox(height: 20.0),
              Text("${widget.itemid}"),
              const SizedBox(height: 20.0),
          ]

      ),
    )
    )
    );
  }
}
