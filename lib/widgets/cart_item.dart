import 'package:flutter/material.dart';
import 'package:curry_virunthu_app/util/const.dart';

class CartItem extends StatefulWidget {
  final int price;
  final String itemid;
  final String label;
  final int quantity;
  final String addon;

  CartItem(
      {required this.price,
      required this.itemid,
      required this.label,
      required this.quantity, required this.addon});

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

                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: RichText(
          text: new TextSpan(
            // Note: Styles for TextSpans must be explicitly defined.
            // Child text spans will inherit styles from parent
            style: new TextStyle(
              fontSize: 15.0,
              color: Colors.white,
                fontWeight: FontWeight.bold
            ),
            children: <InlineSpan>[
              new TextSpan(text: "${widget.label}\n"),
              widget.addon == null ? WidgetSpan(child: SizedBox()):
              WidgetSpan(
                  child: Container(
                    padding: EdgeInsets.only(top:5.0),
                    child: Text("With ${widget.addon}", style: new TextStyle(
                      fontSize: 12.0,
                      color: Colors.orange,
                    )),
                  )
              )
            ],
          ),
        )),


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

        ]));
  }
}
