import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curry_virunthu_app/screens/checkout.dart';
import 'package:curry_virunthu_app/util/temp.dart';
import 'package:curry_virunthu_app/widgets/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/user_session.dart';
import '../widgets/gradient_slide_to_act.dart';

class Cart extends StatefulWidget {
  Cart() {
    FirebaseFirestore.instance
        .collection("customer")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) => {
              if (value["dineInCart"] != null)
                {Temp.dine_in_cart = value["dineInCart"]}
            })
        .catchError((onError) => {print(onError.toString())});
    Temp.curryList = [];
    FirebaseFirestore.instance
        .collection('item')
        .where("category", isEqualTo: "O5ZPchH3c6TEVhjyzeOn")
        .where("isAvailable", isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Temp.curryList.add(doc);
      });
    }).catchError((onError) => {print(onError.toString())});
  }

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool loading = false;

  dynamic orderData = {};

  var checkoutOptions = ["Dine-in", "Takeaway"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title:
              const Text("M Y  C A R T", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 123, 152, 60),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text("\$${findTotal().toString()}",
                    style: const TextStyle(
                      fontSize: 45,
                      color: Colors.orange,
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
                    child:
                    GradientSlideToAct(
                      text: "PROCEED TO CHECKOUT",
                      width: 400,
                      dragableIconBackgroundColor:
                          Color.fromARGB(255, 148, 182, 117),
                      textStyle: TextStyle(color: Colors.black, fontSize: 15),
                      backgroundColor: Color.fromARGB(255, 148, 182, 117),
                      onSubmit: () {

                        //////////////////////////////////////////////////////////////////
                        List<dynamic> foodOrderData = [];
                        List<dynamic> drinksOrderData = [];
                        int total = 0;
                        int quantityTotal = 0;
                        for (int i = 0; i < Temp.dine_in_cart.length; i++) {
                          quantityTotal = (quantityTotal +
                              Temp.dine_in_cart[i]["quantity"]) as int;
                          if (Temp.dine_in_cart[i]["choices"] == null) {
                            total = (total +
                                (Temp.dine_in_cart[i]["quantity"] *
                                    Temp.dine_in_cart[i]["price"])) as int;
                            if (Temp.dine_in_cart[i]["category"] ==
                                "YdpRfe1CwGZ4A3tgtYF9") {
                              drinksOrderData.add({
                                "label": Temp.dine_in_cart[i]["label"],
                                "unitPrice": Temp.dine_in_cart[i]["price"],
                                "quantity": Temp.dine_in_cart[i]["quantity"],
                                "totalPrice": (Temp.dine_in_cart[i]["price"] *
                                    Temp.dine_in_cart[i]["quantity"]) as int,
                                "completedPercent": 0,
                                "completedCount": 0,
                                "category": Temp.dine_in_cart[i]["category"],
                                "state": "ORDERED",
                              });
                            } else {
                              foodOrderData.add({
                                "label": Temp.dine_in_cart[i]["label"],
                                "unitPrice": Temp.dine_in_cart[i]["price"],
                                "quantity": Temp.dine_in_cart[i]["quantity"],
                                "totalPrice": (Temp.dine_in_cart[i]["price"] *
                                    Temp.dine_in_cart[i]["quantity"]) as int,
                                "completedPercent": 0,
                                "completedCount": 0,
                                "category": Temp.dine_in_cart[i]["category"],
                                "state": "ORDERED",
                              });

                              if (Temp.dine_in_cart[i]["addon"] != null) {
                                foodOrderData[foodOrderData.length - 1]
                                        ["addon"] =
                                    "With ${Temp.dine_in_cart[i]["addon"]}";
                              }
                            }
                          } else {
                            for (int j = 0;
                                j < Temp.dine_in_cart[i]["choices"].length;
                                j++) {
                              total = (total +
                                  (Temp.dine_in_cart[i]["choices"][j]
                                          ["quantity"] *
                                      Temp.dine_in_cart[i]["price"])) as int;
                              if (Temp.dine_in_cart[i]["category"] ==
                                  "YdpRfe1CwGZ4A3tgtYF9") {
                                drinksOrderData.add({
                                  "label": Temp.dine_in_cart[i]["choices"][j]
                                      ["choice"],
                                  "unitPrice": Temp.dine_in_cart[i]["price"],
                                  "quantity": Temp.dine_in_cart[i]["choices"][j]
                                      ["quantity"],
                                  "totalPrice": (Temp.dine_in_cart[i]["price"] *
                                      Temp.dine_in_cart[i]["choices"][j]
                                          ["quantity"]) as int,
                                  "completedPercent": 0,
                                  "completedCount": 0,
                                  "category": Temp.dine_in_cart[i]["category"],
                                  "state": "ORDERED",
                                });
                              } else {
                                foodOrderData.add({
                                  "label": Temp.dine_in_cart[i]["choices"][j]
                                      ["choice"],
                                  "unitPrice": Temp.dine_in_cart[i]["price"],
                                  "quantity": Temp.dine_in_cart[i]["choices"][j]
                                      ["quantity"],
                                  "totalPrice": (Temp.dine_in_cart[i]["price"] *
                                      Temp.dine_in_cart[i]["choices"][j]
                                          ["quantity"]) as int,
                                  "completedPercent": 0,
                                  "completedCount": 0,
                                  "category": Temp.dine_in_cart[i]["category"],
                                  "state": "ORDERED",
                                });

                                if (Temp.dine_in_cart[i]["addon"] != null) {
                                  foodOrderData[foodOrderData.length - 1]
                                          ["addon"] =
                                      "With ${Temp.dine_in_cart[i]["addon"]}";
                                }
                              }
                            }
                          }
                        }


                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Checkout(foodOrder: foodOrderData, drinkOrder: drinksOrderData, total: findTotal());
                            },
                          ),
                        );
                      },
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0Xff11998E),
                            Color(0Xff38EF7D),
                          ]),
                    )),
                Expanded(
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 20.0, 10.0, 20.0),
                            child: Temp.dine_in_cart.isEmpty
                                ? buildEmptyCart(context)
                                : buildListCart(context)))),
              ],
            ),
            getLoadingScreen()
          ],
        ));
  }

  getLoadingScreen() {
    if (loading) {
      return Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.2, 0.5],
                colors: [
                  Color.fromARGB(180, 27, 54, 3),
                  Color.fromARGB(180, 0, 0, 0),
                ],
                // stops: [0.0, 0.1],
              ),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
              top: 60,
              left: MediaQuery.of(context).size.width / 4,
              child: Image.asset(
                "assets/loading.gif",
                width: MediaQuery.of(context).size.width / 2,
              )),
          Positioned(
              top: 210,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "C O N F I R M I N G   O R D E R\n. . .",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )))
        ],
      );
    } else {
      return Container();
    }
  }

  buildEmptyCart(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/empty_cart.png",
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.height / 3,
      ),
    );
  }

  findTotal() {
    int total = 0;
    for (int i = 0; i < Temp.dine_in_cart.length; i++) {
      if (Temp.dine_in_cart[i]["choices"] == null) {
        total = (total +
            (Temp.dine_in_cart[i]["quantity"] *
                Temp.dine_in_cart[i]["price"])) as int;
      } else {
        for (int j = 0; j < Temp.dine_in_cart[i]["choices"].length; j++) {
          total = (total +
              (Temp.dine_in_cart[i]["choices"][j]["quantity"] *
                  Temp.dine_in_cart[i]["price"])) as int;
        }
      }
    }
    return total;
  }

  buildListCart(BuildContext context) {
    return Column(children: <Widget>[
      Center(
          child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: Temp.dine_in_cart.length,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (_, index) {
                return Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Temp.dine_in_cart[index]["choices"] == null
                        ? GestureDetector(
                            onHorizontalDragStart: (detail) {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Alert!'),
                                    content: Text(
                                        'Do you want to continue to delete item : ${Temp.dine_in_cart[index]["label"]}?'),
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
                                          Temp.dine_in_cart.removeAt(index);
                                          setState(() {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: CartItem(
                                addon: Temp.dine_in_cart[index]["addon"],
                                price: Temp.dine_in_cart[index]["price"],
                                itemid: Temp.dine_in_cart[index]["itemid"],
                                label: Temp.dine_in_cart[index]["label"],
                                quantity: Temp.dine_in_cart[index]["quantity"]))
                        : ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemCount:
                                Temp.dine_in_cart[index]["choices"].length,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (_, index2) {
                              return GestureDetector(
                                  onHorizontalDragStart: (detail) {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Alert!'),
                                          content: Text(
                                              'Do you want to continue to delete item : ${Temp.dine_in_cart[index]["choices"][index2]["choice"]}?'),
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
                                                Temp.dine_in_cart[index]
                                                        ["choices"]
                                                    .removeAt(index2);
                                                if (Temp
                                                        .dine_in_cart[index]
                                                            ["choices"]
                                                        .length ==
                                                    0) {
                                                  Temp.dine_in_cart
                                                      .removeAt(index);
                                                }
                                                setState(() {
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: CartItem(
                                      addon: Temp.dine_in_cart[index]["addon"],
                                      price: Temp.dine_in_cart[index]["price"],
                                      itemid: Temp.dine_in_cart[index]
                                          ["itemid"],
                                      label: Temp.dine_in_cart[index]["choices"]
                                          [index2]["choice"],
                                      quantity: Temp.dine_in_cart[index]
                                          ["choices"][index2]["quantity"]));
                            },
                            separatorBuilder: (_, index) {
                              return const SizedBox(
                                height: 5,
                              );
                            }));
              },
              separatorBuilder: (_, index) {
                return const SizedBox(
                  height: 5,
                );
              })),
      const SizedBox(height: 50.0),
    ]);
  }
}
