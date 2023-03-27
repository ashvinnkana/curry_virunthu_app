import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curry_virunthu_app/util/user_session.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'order_list_item.dart';

class OrderItem extends StatefulWidget {
  final String id;
  final DateTime orderTime;
  final int completedPercent;
  final String state;
  final String orderType;
  final dynamic tableNum;
  final int total;
  final List<dynamic> foodOrder;
  final List<dynamic> drinkOrder;
  final int completedCount;
  final int orderQuantity;

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
      required this.drinkOrder,
      required this.completedCount,
      required this.orderQuantity});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  dynamic stateColor = {
    "ORDERED": Color(0xffeeeeee),
    "PREPARING": Color(0xffe8743e),
    "BILLING": Color(0xff8bd36d),
    "PAID": Color(0xff3097c2),
    "NOT-PAID": Color(0xffea4e4e)
  };

  var isMore = false;

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
                  padding: EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                  child: Text(
                    "${DateFormat('dd/MM/yyyy, hh:mm aa').format(widget.orderTime)}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 187, 187, 187),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0),
                  child: Text(
                    "${widget.orderType.toUpperCase()}${widget.orderType == 'Dine-in' ? ' | ' + widget.tableNum : ''}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: stateColor[widget.state],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "\$${widget.total}",
                style: TextStyle(color: Colors.white, fontSize: 35),
              ),
              SizedBox(height: 10.0),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0),
                  child: Text(
                    "${widget.completedPercent}%",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: stateColor[widget.state],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              LinearProgressIndicator(
                value: widget.completedPercent / 100,
                color: stateColor[widget.state],
              ),
              SizedBox(height: 5.0),
              Text(
                "${widget.state}",
                style: TextStyle(
                    color: stateColor[widget.state],
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              SizedBox(height: 20.0),
              isMore
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isMore = false;
                              });
                            },
                            child: Text(
                              "<< View Less",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: stateColor[widget.state],
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            )),
                      ),
                    )
                  : SizedBox(),
              !isMore
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isMore = true;
                            });
                          },
                          child: Text(
                            "View More >>",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: stateColor[widget.state],
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 10.0),
              isMore
                  ? Column(
                      children: [
                        buildFoodListCart(context),
                        buildDrinkListCart(context),
                      ],
                    )
                  : SizedBox(),
              SizedBox(height: 20.0),
              Container(
                color: const Color.fromARGB(255, 143, 143, 143),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                    child: Text(
                      "Order ID: ${widget.id}",
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildFoodListCart(BuildContext context) {
    return Column(children: <Widget>[
      Center(
          child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: widget.foodOrder.length,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (_, index) {
                return Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: GestureDetector(
                        onHorizontalDragStart: (detail) {
                          if (widget.foodOrder[index]["state"] == 'ORDERED' &&
                              Session.userData["admin"]) {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Alert!'),
                                  content: Text(
                                      'Do you want to continue to remove item : ${widget.foodOrder[index]["label"]}?'),
                                  actions: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: const Text('No'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: const Text('Yes'),
                                      onPressed: () {
                                        widget.foodOrder[index]["state"] =
                                            "REMOVED";
                                        var tempCompletedCount =
                                            widget.completedCount -
                                                widget.foodOrder[index]
                                                    ["completedCount"];
                                        var tempOrderQuantity = widget
                                                .orderQuantity -
                                            widget.foodOrder[index]["quantity"];
                                        widget.foodOrder[index]
                                            ["completedCount"] = 0;
                                        var tempCompletedPercentage;
                                        if (tempOrderQuantity == 0)
                                          tempCompletedPercentage = 100;
                                        else
                                          tempCompletedPercentage =
                                              (tempCompletedCount /
                                                      tempOrderQuantity) *
                                                  100;

                                        FirebaseFirestore.instance
                                            .collection("order")
                                            .doc(widget.id)
                                            .update({
                                              "foodOrder": widget.foodOrder,
                                              "completedCount":
                                                  tempCompletedCount,
                                              "orderQuantity":
                                                  tempOrderQuantity,
                                              "total": widget.total -
                                                  widget.foodOrder[index]
                                                      ["totalPrice"],
                                              "completedPercent":
                                                  tempCompletedPercentage
                                            })
                                            .then((value) => {})
                                            .catchError((error) => print(
                                                "Failed to update cart: $error"));
                                        setState(() {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: OrderListItem(
                            addon: widget.foodOrder[index]["addon"],
                            price: widget.foodOrder[index]["unitPrice"],
                            itemid: widget.foodOrder[index]["label"],
                            label: widget.foodOrder[index]["label"],
                            quantity: widget.foodOrder[index]["quantity"],
                            state: widget.foodOrder[index]["state"],
                            orderState: widget.state)));
              },
              separatorBuilder: (_, index) {
                return const SizedBox(
                  height: 5,
                );
              })),
      const SizedBox(height: 10.0),
    ]);
  }

  buildDrinkListCart(BuildContext context) {
    return Column(children: <Widget>[
      Center(
          child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: widget.drinkOrder.length,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (_, index) {
                return Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: GestureDetector(
                        onHorizontalDragStart: (detail) {
                          if (widget.drinkOrder[index]["state"] == 'ORDERED' &&
                              Session.userData["admin"]) {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Alert!'),
                                  content: Text(
                                      'Do you want to continue to remove item : ${widget.drinkOrder[index]["label"]}?'),
                                  actions: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: const Text('No'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: const Text('Yes'),
                                      onPressed: () {
                                        widget.drinkOrder[index]["state"] =
                                            "REMOVED";
                                        var tempCompletedCount =
                                            widget.completedCount -
                                                widget.drinkOrder[index]
                                                    ["completedCount"];
                                        var tempOrderQuantity =
                                            widget.orderQuantity -
                                                widget.drinkOrder[index]
                                                    ["quantity"];
                                        widget.drinkOrder[index]
                                            ["completedCount"] = 0;
                                        var tempCompletedPercentage;
                                        if (tempOrderQuantity == 0)
                                          tempCompletedPercentage = 100;
                                        else
                                          tempCompletedPercentage =
                                              (tempCompletedCount /
                                                      tempOrderQuantity) *
                                                  100;

                                        FirebaseFirestore.instance
                                            .collection("order")
                                            .doc(widget.id)
                                            .update({
                                              "drinkOrder": widget.drinkOrder,
                                              "completedCount":
                                                  tempCompletedCount,
                                              "orderQuantity":
                                                  tempOrderQuantity,
                                              "total": widget.total -
                                                  widget.drinkOrder[index]
                                                      ["totalPrice"],
                                              "completedPercent":
                                                  tempCompletedPercentage
                                            })
                                            .then((value) => {})
                                            .catchError((error) => print(
                                                "Failed to update cart: $error"));
                                        setState(() {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: OrderListItem(
                            addon: widget.drinkOrder[index]["addon"],
                            price: widget.drinkOrder[index]["unitPrice"],
                            itemid: widget.drinkOrder[index]["label"],
                            label: widget.drinkOrder[index]["label"],
                            quantity: widget.drinkOrder[index]["quantity"],
                            state: widget.drinkOrder[index]["state"],
                            orderState: widget.state)));
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
