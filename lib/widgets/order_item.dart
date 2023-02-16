import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curry_virunthu_app/util/temp.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'cart_item.dart';
import 'linear_progress.dart';
import 'order_list_item.dart';

class OrderItem extends StatefulWidget {
  final String id;
  final DateTime orderTime;
  final int completedPercent;
  final String state;
  final String orderType;
  final String tableNum;
  final int total;
  final List<dynamic> foodOrder;
  final List<dynamic> drinkOrder;

  //DateFormat('dd/MM/yyyy, HH:mm').format(order["orderTime"].toDate()
  OrderItem(
      {required this.id,
      required this.orderTime,
      required this.completedPercent,
      required this.state,
      required this.orderType,
      required this.tableNum,
      required this.total,
      required this.foodOrder,
      required this.drinkOrder});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

  dynamic stateColor = {
    "ORDERED" : Color(0xffe8743e),
    "PREPARING" : Color(0xffe8743e),
    "BILLING" : Color(0xff53a233),
    "PAID" : Color(0xff3097c2),
    "NOT-PAID" : Color(0xffea4e4e)
  };



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 3.0,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(left:15.0, right:15.0, top:5.0, bottom:5.0),
                  child:Text("${DateFormat('dd/MM/yyyy, hh:mm aa').format(widget.orderTime)}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 187, 187, 187),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),),),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(left:15.0, right:15.0,bottom:5.0),
                  child:Text("${widget.orderType.toUpperCase()}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: stateColor[widget.state],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),),),
              ),

                SizedBox(height: 10.0),
                Text("\$${widget.total}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35
                ),),
                SizedBox(height: 10.0),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(left:15.0, right:15.0,bottom:5.0),
                  child:Text("${widget.completedPercent}%",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: stateColor[widget.state],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),),),
              ),
              LinearProgressIndicator(
                value: widget.completedPercent/100,
                color:stateColor[widget.state],
              ),
              SizedBox(height: 5.0),
              Text("${widget.state}",
                style: TextStyle(
                    color: stateColor[widget.state],
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),),
              SizedBox(height: 20.0),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(left:15.0),
                  child:Text("view more >>",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: stateColor[widget.state],
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),),),
              ),
              SizedBox(height: 10.0),
              buildListCart(context, widget.foodOrder),
              buildListCart(context, widget.drinkOrder),
              SizedBox(height: 20.0),
              Container(
                color: const Color.fromARGB(255, 143, 143, 143),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: EdgeInsets.only(left:15.0, right:15.0, top:5.0, bottom:5.0),
                    child:Text(
                      "Order ID: ${widget.id}",
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.black
                      ),
                      textAlign: TextAlign.left,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildListCart(BuildContext context, data) {
    return Column(children: <Widget>[
      Center(
          child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: data.length,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (_, index) {
                return Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: OrderListItem(
                        addon: data[index]["addon"],
                        price: data[index]["unitPrice"],
                        itemid: data[index]["label"],
                        label: data[index]["label"],
                        quantity: data[index]["quantity"],
                        state: data[index]["state"],
                    orderState: widget.state));
              },
              separatorBuilder: (_, index) {
                return const SizedBox(
                  height: 5,
                );
              })),
      const SizedBox(height: 10.0),
    ]);
  }

}
