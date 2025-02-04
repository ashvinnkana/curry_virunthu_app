import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curry_virunthu_app/util/temp.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../screens/product_view.dart';

class MenuItems extends StatefulWidget {
  final String id;
  final String img;
  final String title;
  final String desc;
  final String buyCount;
  final bool isAvailable;
  final String price;
  final String category;
  final List<dynamic> choices;
  final dynamic data;

  MenuItems(
      {required this.id,
      required this.img,
      required this.title,
      required this.desc,
      required this.buyCount,
      required this.isAvailable,
      required this.price,
      required this.choices,
      required this.category,
      required this.data});

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItems> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 3.0,
          child: Column(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 3.7,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.img,
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
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            stops: [0.2, 0.7],
                            colors: [
                              Color.fromARGB(50, 0, 0, 0),
                              Color.fromARGB(100, 0, 0, 0),
                            ],
                          ),
                        ),
                        height: MediaQuery.of(context).size.height / 3.7,
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
                            child: int.parse(widget.buyCount) > 5
                                ? Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.pink,
                                        size: 12,
                                      ),
                                      Text(
                                        " ${widget.buyCount} ",
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text(
                                    " NEW ",
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.yellow),
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6.0,
                        left: 6.0,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0)),
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "A\$ ${widget.price}",
                              style: const TextStyle(
                                fontSize: 25.0,
                                color: Colors.lightGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 6.0,
                          right: 6.0,
                          child: GestureDetector(
                            child: Card(
                              color: const Color.fromRGBO(0, 0, 0, 0.4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                      size: 25,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return ProductView(widget.data, widget.id);
                                  },
                                ),
                              );
                            },
                          )),
                    ],
                  )),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    widget.desc,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              checkCartforItem(widget.id) == ""
                  ? buildSelect(widget.choices)
                  : buildAddedToCart(widget.choices),
              widget.category == "K2vR0XROjDoauN5svgLI" &&
                      widget.data["addon"] == true
                  ? buildAddons()
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  buildAddedToCart(List choices) {
    return choices.length == 0
        ? Stack(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        GestureDetector(
                          onHorizontalDragEnd: (_) {
                            deleteItemInCart(widget.id, widget.title);
                            setState(() {});
                          },
                          child: TextButton(
                            style: TextButton.styleFrom(
                                //<-- SEE HERE
                                side: BorderSide(
                                    width: 1.0, color: Colors.lightGreen),
                                backgroundColor: Colors.lightGreen,
                                foregroundColor: Colors.black,
                                alignment: Alignment.centerLeft),
                            onPressed: () {
                              setupCartList();
                              setState(() {});
                            },
                            child: const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text('ADDED TO CART')),
                          ),
                        )
                      ])),
              Positioned(
                right: 30,
                top: 28,
                child: Container(
                    width: 40.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(width: 1.5)),
                    child: Center(
                        child: Text(
                      "${checkCartforItem(widget.id)["quantity"]}",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ))),
              )
            ],
          )
        : Padding(
            padding: EdgeInsets.all(15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "- - - - -   ADDED TO CART   - - - - -",
                    style: TextStyle(color: Colors.lightGreen),
                  ),
                  const SizedBox(height: 10.0),
                  ListView.separated(
                      primary: true,
                      shrinkWrap: true,
                      itemCount: widget.choices.length,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (_, index) {
                        return widget.choices[index]["isAvailable"]
                            ? (checkCartforChoice(checkCartforItem(widget.id),
                                        widget.choices[index]["label"]) ==
                                    "-1"
                                ? TextButton(
                                    style: TextButton.styleFrom(
                                        //<-- SEE HERE
                                        side: BorderSide(
                                            width: 1.0,
                                            color: Colors.lightGreen),
                                        backgroundColor: null,
                                        foregroundColor: Colors.lightGreen,
                                        alignment: Alignment.center),
                                    onPressed: () {
                                      setupCartListWithChoice(
                                          widget.choices[index]["label"]);
                                      setState(() {});
                                    },
                                    child: Text(
                                        '${widget.choices[index]["label"]}'),
                                  )
                                : Stack(
                                    children: <Widget>[
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            GestureDetector(
                                                onHorizontalDragEnd: (_) {
                                                  deleteChoiceInCart(
                                                      widget.id,
                                                      widget.title,
                                                      widget.choices[index]
                                                          ["label"]);
                                                  setState(() {});
                                                },
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                      //<-- SEE HERE
                                                      side: BorderSide(
                                                          width: 1.0,
                                                          color: Colors
                                                              .lightGreen),
                                                      backgroundColor:
                                                          Colors.lightGreen,
                                                      foregroundColor:
                                                          Colors.black,
                                                      alignment:
                                                          Alignment.centerLeft),
                                                  onPressed: () {
                                                    setupCartListWithChoice(
                                                        widget.choices[index]
                                                            ["label"]);
                                                    setState(() {});
                                                  },
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                          "${widget.choices[index]["label"]}")),
                                                )),
                                          ]),
                                      Positioned(
                                        right: 15,
                                        top: 15,
                                        child: Container(
                                            width: 40.0,
                                            height: 20.0,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                border: Border.all(width: 1.5)),
                                            child: Center(
                                                child: Text(
                                              "${checkCartforChoice(checkCartforItem(widget.id), widget.choices[index]["label"])}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ))),
                                      )
                                    ],
                                  ))
                            : SizedBox();
                      },
                      separatorBuilder: (_, index) {
                        return SizedBox(
                          height: 5,
                        );
                      })
                ]));
  }

  checkCartforChoice(data, choice) {
    for (int j = 0; j < data["choices"].length; j++) {
      if (data["choices"][j]["choice"] == choice) {
        return data["choices"][j]["quantity"].toString();
      }
    }
    return "-1";
  }

  checkCartforItem(String id) {
    for (int i = 0; i < Temp.dine_in_cart.length; i++) {
      if (Temp.dine_in_cart[i]["itemid"] == id) {
        return Temp.dine_in_cart[i];
      }
    }
    return "";
  }

  buildAddons() {
    try {
      if (checkCartforItem(widget.id)["quantity"] > 0) {
        return Padding(
            padding: EdgeInsets.all(15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "- - - - -   FREE CURRY ADDONS CHOICES  - - - - -",
                    style: TextStyle(color: Colors.lightGreen),
                  ),
                  const SizedBox(height: 10.0),
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
                                groupValue:
                                    checkCartforItem(widget.id)["addon"],
                                onChanged: (flag) {
                                  setState(() {
                                    checkCartforItem(widget.id)["addon"] =
                                        Temp.curryList[index]["label"];
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
                                    color:
                                        Temp.curryList[index]["isVeg"] == true
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
      } else {
        return SizedBox();
      }
    } catch (e) {
      return SizedBox();
    }
  }

  buildSelect(List choices) {
    return Padding(
        padding: EdgeInsets.all(15),
        child: choices.length == 0
            ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      //<-- SEE HERE
                      side: BorderSide(width: 1.0, color: Colors.lightGreen),
                      backgroundColor: null,
                      foregroundColor: Colors.lightGreen,
                      alignment: Alignment.center),
                  onPressed: () {
                    setupCartList();
                    setState(() {});
                  },
                  child: Text('ADD TO CART'),
                ),
              ])
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    Text(
                      "- - - - -   ADD TO CART   - - - - -",
                      style: TextStyle(color: Colors.lightGreen),
                    ),
                    const SizedBox(height: 10.0),
                    ListView.separated(
                        primary: true,
                        shrinkWrap: true,
                        itemCount: widget.choices.length,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (_, index) {
                          return widget.choices[index]["isAvailable"]
                              ? TextButton(
                                  style: TextButton.styleFrom(
                                      //<-- SEE HERE
                                      side: BorderSide(
                                          width: 1.0, color: Colors.lightGreen),
                                      backgroundColor: null,
                                      foregroundColor: Colors.lightGreen,
                                      alignment: Alignment.center),
                                  onPressed: () {
                                    setupCartListWithChoice(
                                        widget.choices[index]["label"]);
                                    setState(() {});
                                  },
                                  child:
                                      Text('${widget.choices[index]["label"]}'),
                                )
                              : SizedBox();
                        },
                        separatorBuilder: (_, index) {
                          return SizedBox(
                            height: 5,
                          );
                        })
                  ]));
  }

  void setupCartListWithChoice(String choice) {
    for (int i = 0; i < Temp.dine_in_cart.length; i++) {
      if (Temp.dine_in_cart[i]["itemid"] == widget.id) {
        for (int j = 0; j < Temp.dine_in_cart[i]["choices"].length; j++) {
          if (Temp.dine_in_cart[i]["choices"][j]["choice"] == choice) {
            Temp.dine_in_cart[i]["choices"][j]["quantity"]++;
            Temp.dine_in_cart[i]["quantity"]++;
            return;
          }
        }
        Temp.dine_in_cart[i]["choices"].add({"choice": choice, "quantity": 1});
        Temp.dine_in_cart[i]["quantity"]++;
        return;
      }
    }
    Map<String, dynamic> item = {
      "itemid": widget.id,
      "label": widget.title,
      "price": int.parse(widget.price),
      "quantity": 1,
      "category": widget.category,
      "choices": [
        {"choice": choice, "quantity": 1}
      ]
    };
    Temp.dine_in_cart.add(item);
    return;
  }

  void setupCartList() {
    for (int i = 0; i < Temp.dine_in_cart.length; i++) {
      if (Temp.dine_in_cart[i]["itemid"] == widget.id) {
        Temp.dine_in_cart[i]["quantity"]++;
        return;
      }
    }
    Map<String, dynamic> item = {
      "itemid": widget.id,
      "label": widget.title,
      "price": int.parse(widget.price),
      "choices": null,
      "category": widget.category,
      "quantity": 1
    };
    Temp.dine_in_cart.add(item);
    return;
  }

  void deleteItemInCart(String id, String title) {
    Temp.dine_in_cart.remove(checkCartforItem(id));
    Fluttertoast.showToast(
        msg: title + " Removed from Cart!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void deleteChoiceInCart(String id, String title, String choice) {
    for (int i = 0; i < Temp.dine_in_cart.length; i++) {
      if (Temp.dine_in_cart[i]["itemid"] == id) {
        if (Temp.dine_in_cart[i]["choices"].length > 1) {
          for (int j = 0; j < Temp.dine_in_cart[i]["choices"].length; j++) {
            if (Temp.dine_in_cart[i]["choices"][j]["choice"] == choice) {
              Temp.dine_in_cart[i]["quantity"] = Temp.dine_in_cart[i]
                      ["quantity"] -
                  (Temp.dine_in_cart[i]["choices"][j]["quantity"]) as int;
              Temp.dine_in_cart[i]["choices"].removeAt(j);
              Fluttertoast.showToast(
                  msg: choice + " Removed from Cart!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        } else {
          Temp.dine_in_cart.removeAt(i);
          Fluttertoast.showToast(
              msg: title + " Removed from Cart!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
  }
}
