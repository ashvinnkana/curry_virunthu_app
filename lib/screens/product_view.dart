import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:curry_virunthu_app/screens/main_screen.dart';
import 'package:curry_virunthu_app/screens/today_menu.dart';
import 'package:curry_virunthu_app/util/temp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:flutter/services.dart';
import '../widgets/gradient_slide_to_act.dart';
import 'add_to_cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductView extends StatefulWidget {
  final Map<String, dynamic> product;
  final String item_id;

  ProductView(this.product, this.item_id);

  @override
  _ProductViewState createState() => _ProductViewState(product, item_id);
}

class _ProductViewState extends State<ProductView> {
  final String item_id;
  final Map<String, dynamic> product;
  int currentChoice = 0;
  dynamic quantity = 1;
  bool isAdded = false;

  _ProductViewState(this.product, this.item_id);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (isAdded) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return MainScreen(1, "All");
                },
              ),
            );
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 30, 30, 30),
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
                product['label'].toString().toUpperCase().replaceAll("", " ")),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 123, 152, 60),
          ),
          body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        child: CachedNetworkImage(
                          imageUrl: product["img"],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            )),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            stops: [0.2, 0.7],
                            colors: [
                              Color.fromARGB(100, 0, 0, 0),
                              Color.fromARGB(50, 0, 0, 0),
                            ],
                          ),
                        ),
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Positioned(
                        bottom: 6.0,
                        right: 6.0,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                  size: 15,
                                ),
                                Text(
                                  " ${product["buyCount"]} ",
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Price",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 5.0),
                  Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "A\$ ${product["price"]}",
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreenAccent),
                      )),
                  const SizedBox(height: 20.0),
                  Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: Text(
                        "${product["description"]}",
                        style: const TextStyle(fontSize: 15),
                      )),
                  const SizedBox(height: 20.0),
                  const Divider(color: Colors.white),
                  const SizedBox(height: 20.0),
                  product["choices"].length != 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Pick your choice",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightGreen),
                                )),
                            const SizedBox(height: 10.0),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: listItemChoice()),
                            const SizedBox(height: 20.0),
                          ],
                        )
                      : SizedBox(),
                  const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Quantity",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen),
                      )),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QuantityInput(
                        value: quantity,
                        onChanged: (value) => setState(() =>
                            quantity = int.parse(value.replaceAll(',', ''))),
                        minValue: 1,
                        buttonColor: Color.fromARGB(255, 68, 67, 67),
                      ),
                    ],
                  ),
                  product["category"] == 'K2vR0XROjDoauN5svgLI' &&
                          product["addon"] == true
                      ? const SizedBox(height: 20.0)
                      : SizedBox(),
                  product["category"] == 'K2vR0XROjDoauN5svgLI' &&
                          product["addon"] == true
                      ? Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Container(
                              child: Text(
                            "Inclusive Curry Addon Choices",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightGreen),
                          )),
                        )
                      : SizedBox(),
                  product["category"] == 'K2vR0XROjDoauN5svgLI' &&
                          product["addon"] == true
                      ? buildAddons()
                      : SizedBox(),
                  const SizedBox(height: 30.0),
                  Padding(
                      padding: const EdgeInsets.only(left: 70.0, right: 70.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreen.shade800,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            isAdded = true;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  HapticFeedback.heavyImpact();
                                  SystemSound.play(SystemSoundType.click);

                                  product["choices"].length != 0
                                      ? setupCartListWithChoice()
                                      : setupCartListWithoutChoice();
                                  FirebaseFirestore.instance
                                      .collection("customer")
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .update({"dineInCart": Temp.dine_in_cart})
                                      .then((value) => print("Cart Updated"))
                                      .catchError((error) => print(
                                          "Failed to update cart: $error"));

                                  return AddToCart();
                                },
                              ),
                            );
                          },
                          child: Text("ADD TO CART"))),
                  const SizedBox(height: 20.0),
                ],
              )),
        ));
  }

  buildAddons() {
    return Padding(
        padding: EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                  child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (_, index) {
                  if (Temp.curryList[index]["isAvailable"]) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                            value: Temp.curryList[index]["label"],
                            groupValue: addonChoice,
                            onChanged: (flag) {
                              setState(() {
                                addonChoice = Temp.curryList[index]["label"];
                              });
                            }),
                        Expanded(
                          child: Text(
                            Temp.curryList[index]["label"].toString(),
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.only(left: 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0)),
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              Temp.curryList[index]["isVeg"] == true
                                  ? 'VEG'
                                  : "NON-VEG",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Temp.curryList[index]["isVeg"] == true
                                    ? Colors.lightGreenAccent
                                    : Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                },
                itemCount: Temp.curryList.length,
                separatorBuilder: (_, index) {
                  return SizedBox(
                    height: 5,
                  );
                },
              ))
            ]));
  }

  String addonChoice = "";

  void setupCartListWithChoice() {
    for (int i = 0; i < Temp.dine_in_cart.length; i++) {
      if (Temp.dine_in_cart[i]["itemid"] == item_id) {
        for (int j = 0; j < Temp.dine_in_cart[i]["choices"].length; j++) {
          if (Temp.dine_in_cart[i]["choices"][j]["choice"] ==
              product["choices"][currentChoice]["label"]) {
            Temp.dine_in_cart[i]["choices"][j]["quantity"] =
                Temp.dine_in_cart[i]["choices"][j]["quantity"] + quantity;
            Temp.dine_in_cart[i]["quantity"] =
                Temp.dine_in_cart[i]["quantity"] + quantity;
            if (addonChoice != "") {
              Temp.dine_in_cart[i]["addon"] = addonChoice;
            }
            return;
          }
        }
        Temp.dine_in_cart[i]["choices"].add({
          "choice": product["choices"][currentChoice]["label"],
          "quantity": quantity
        });
        Temp.dine_in_cart[i]["quantity"] =
            Temp.dine_in_cart[i]["quantity"] + quantity;
        if (addonChoice != "") {
          Temp.dine_in_cart[i]["addon"] = addonChoice;
        }
        return;
      }
    }

    Map<String, dynamic> item = {};

    if (addonChoice != "") {
      item = {
        "category": product["category"],
        "itemid": item_id,
        "label": product["label"],
        "price": int.parse(product["price"]),
        "addon": addonChoice,
        "choices": [
          {
            "choice": product["choices"][currentChoice]["label"],
            "quantity": quantity
          }
        ],
        "quantity": quantity
      };
    } else {
      item = {
        "category": product["category"],
        "itemid": item_id,
        "label": product["label"],
        "price": int.parse(product["price"]),
        "choices": [
          {
            "choice": product["choices"][currentChoice]["label"],
            "quantity": quantity
          }
        ],
        "quantity": quantity
      };
    }
    Temp.dine_in_cart.add(item);
    return;
  }

  void setupCartListWithoutChoice() {
    for (int i = 0; i < Temp.dine_in_cart.length; i++) {
      if (Temp.dine_in_cart[i]["itemid"] == item_id) {
        Temp.dine_in_cart[i]["quantity"] =
            Temp.dine_in_cart[i]["quantity"] + quantity;
        if (addonChoice != "") {
          Temp.dine_in_cart[i]["addon"] = addonChoice;
        }
        return;
      }
    }

    Map<String, dynamic> item = {};

    if (addonChoice != "") {
      item = {
        "category": product["category"],
        "itemid": item_id,
        "label": product["label"],
        "price": int.parse(product["price"]),
        "choices": null,
        "quantity": quantity,
        "addon": addonChoice
      };
    } else {
      item = {
        "category": product["category"],
        "itemid": item_id,
        "label": product["label"],
        "price": int.parse(product["price"]),
        "choices": null,
        "quantity": quantity
      };
    }

    Temp.dine_in_cart.add(item);
    return;
  }

  listItemChoice() {
    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (_, index) {
        if (product["choices"][index]["isAvailable"]) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio(
                  value: index,
                  groupValue: currentChoice,
                  onChanged: (flag) {
                    setState(() {
                      currentChoice = index;
                    });
                  }),
              Expanded(
                child: Text(
                  product["choices"][index]["label"].toString(),
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.only(left: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    product["choices"][index]["isVeg"] == true
                        ? 'VEG'
                        : "NON-VEG",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: product["choices"][index]["isVeg"] == true
                          ? Colors.lightGreenAccent
                          : Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15.0, right: 10.0),
                child: Text(
                  "SOLD OUT",
                  style: TextStyle(fontSize: 15.0, color: Colors.red),
                ),
              ),
              Expanded(
                child: Text(
                  product["choices"][index]["label"].toString(),
                  style: TextStyle(fontSize: 15.0, color: Colors.grey),
                ),
              ),
              Card(
                margin: EdgeInsets.only(left: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    product["choices"][index]["isVeg"] == true
                        ? 'VEG'
                        : "NON-VEG",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: product["choices"][index]["isVeg"] == true
                          ? Colors.lightGreen
                          : Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          );
        }
      },
      itemCount: product["choices"].length,
      separatorBuilder: (_, index) {
        return SizedBox(
          height: 5,
        );
      },
    );
  }
}
