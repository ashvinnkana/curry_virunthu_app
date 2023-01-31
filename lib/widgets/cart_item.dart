import 'package:flutter/material.dart';
import 'package:curry_virunthu_app/util/const.dart';

class CartItem extends StatefulWidget {
  final int price;
  final String itemid;
  final String label;
  final int quantity;

  CartItem(
      {required this.price,
      required this.itemid,
      required this.label,
      required this.quantity});

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 0.0,
        ),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      width: 35.0,
                      height: 35.0,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 126, 126, 126),
                          shape: BoxShape.rectangle,
                          border: Border.all(width: 1.5),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Center(
                          child: Text(
                        "${widget.quantity}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ))),
                  const SizedBox(width: 15.0),
                  Text(
                    "${widget.label}",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              Text(
                "\$${widget.price * widget.quantity}",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 10.0),
        ]));
  }
}
