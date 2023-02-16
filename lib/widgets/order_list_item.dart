import 'package:flutter/material.dart';
import 'package:curry_virunthu_app/util/const.dart';

class OrderListItem extends StatefulWidget {
  final int price;
  final String itemid;
  final String label;
  final int quantity;
  final String addon;
  final String state;
  final String orderState;

  OrderListItem(
      {required this.price,
      required this.itemid,
      required this.label,
      required this.quantity, required this.addon, required this.state, required this.orderState});

  @override
  _OrderListItemState createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {

  dynamic itemStateColor ={
    "ORDERED" : {
      "ORDERED" : Color(0xffeeeeee),
      "PREPARING" : Color(0xffe8743e),
      "DONE" : Color(0xff53a233),
      "REMOVED" : Color(0xffea4e4e)
    },
    "PREPARING" : {
      "ORDERED" : Color(0xffeeeeee),
      "PREPARING" : Color(0xffe8743e),
      "DONE" : Color(0xff53a233),
      "REMOVED" : Color(0xffea4e4e)
    },
    "BILLING" : {
      "DONE" : Color(0xff53a233),
      "REMOVED" : Color(0xffea4e4e)
    },
    "PAID" : {
      "DONE" : Color(0xff3097c2),
      "REMOVED" : Color(0xffea4e4e)
    },
    "NOT-PAID" : {
      "DONE" : Color(0xffea4e4e),
      "REMOVED" : Color(0xffea4e4e)
    }
  };

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
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                          color:Color.fromARGB(255, 61, 61, 61),
                          shape: BoxShape.rectangle,
                          border: Border.all(width: 1.5, color: Colors.white),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Center(
                          child: Text(
                        "${widget.quantity}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ))),
                  const SizedBox(width: 15.0),

                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: RichText(
          text: new TextSpan(
            style: new TextStyle(
              fontSize: 13.0,
              color: itemStateColor[widget.orderState][widget.state],
            ),
            children: <InlineSpan>[
              new TextSpan(text: "${widget.label}\n"),
              widget.addon == null ? WidgetSpan(child: SizedBox()):
              WidgetSpan(
                  child: Container(
                    padding: EdgeInsets.only(top:5.0),
                    child: Text("${widget.addon}", style: new TextStyle(
                      fontSize: 11.0,
                      color: Colors.yellow,
                    )),
                  )
              ),
            ],
          ),
        )),

               ],
              ),
              Text(
                "\$${widget.price * widget.quantity}",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 1.0),
          Divider(
            color: Colors.grey,
          ),

        ]));
  }
}
