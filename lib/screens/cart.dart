import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curry_virunthu_app/util/temp.dart';
import 'package:curry_virunthu_app/widgets/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  TextEditingController table_controller = TextEditingController();
  TextEditingController phone_controller = TextEditingController();

  String choosenCheckout = "Dine-in";

  var checkoutOptions = ["Dine-in"];

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
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                child: Temp.dine_in_cart.isEmpty
                    ? buildEmptyCart(context)
                    : buildListCart(context))));
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
                        ? CartItem(
                            addon: Temp.dine_in_cart[index]["addon"],
                            price: Temp.dine_in_cart[index]["price"],
                            itemid: Temp.dine_in_cart[index]["itemid"],
                            label: Temp.dine_in_cart[index]["label"],
                            quantity: Temp.dine_in_cart[index]["quantity"])
                        : ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemCount:
                                Temp.dine_in_cart[index]["choices"].length,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (_, index2) {
                              return CartItem(
                                  addon: Temp.dine_in_cart[index]["addon"],
                                  price: Temp.dine_in_cart[index]["price"],
                                  itemid: Temp.dine_in_cart[index]["itemid"],
                                  label: Temp.dine_in_cart[index]["choices"]
                                      [index2]["choice"],
                                  quantity: Temp.dine_in_cart[index]["choices"]
                                      [index2]["quantity"]);
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
      const SizedBox(height: 10.0),
      Padding(
          padding: const EdgeInsets.only(left: 85.0, right: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                "T O T A L",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold),
              ),
              Text("\$${findTotal().toString()}",
                  style: const TextStyle(
                      fontSize: 25,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold)),
            ],
          )),
      const SizedBox(height: 30.0),
      Container(
        width: MediaQuery.of(context).size.width,
        color: const Color.fromRGBO(79, 79, 79, 1.0),
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Checkout Option : ",
                        style: TextStyle(
                            color: Color.fromARGB(255, 166, 232, 20),
                            fontSize: 15),
                      ),
                      DropdownButton(
                          value: choosenCheckout,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: checkoutOptions.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              choosenCheckout = newValue!;
                            });
                          }),
                    ])),
            Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Table Number : ",
                        style: TextStyle(
                            color: Color.fromARGB(255, 166, 232, 20),
                            fontSize: 15),
                      ),
                      Container(
                          width: 70,
                          child: TextField(
                            controller: table_controller,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "-",
                            ),
                            onChanged: (text) => setState(() {}),
                          )),
                    ])),
            const SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cutomer Number : ",
                        style: TextStyle(
                            color: Color.fromARGB(255, 166, 232, 20),
                            fontSize: 15),
                      ),
                      Container(
                          width: 70,
                          child: TextField(
                            controller: phone_controller,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "-",
                            ),
                            onChanged: (text) => setState(() {}),
                          )),
                    ])),
            const SizedBox(height: 20.0),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: (choosenCheckout == "Dine-in" &&
                            table_controller.text == "")
                        ? ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(255, 93, 93, 93),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Cannot Proceed'),
                                    content: const Text('All Fields Required!'),
                                    actions: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        child: const Text('Okay'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.block,
                              size: 24.0,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            label: const Text("C O N F I R M   O R D E R",
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255))),
                          )
                        : ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary:
                                    const Color.fromARGB(255, 123, 152, 60),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () {
                              //////////////////////////////////////////////////////////////////
                              List<dynamic> foodOrderData = [];
                              List<dynamic> drinksOrderData = [];
                              int total = 0;
                              int quantityTotal = 0;
                              for (int i = 0;
                                  i < Temp.dine_in_cart.length;
                                  i++) {
                                quantityTotal = (quantityTotal +
                                    Temp.dine_in_cart[i]["quantity"]) as int;
                                if (Temp.dine_in_cart[i]["choices"] == null) {
                                  total = (total +
                                          (Temp.dine_in_cart[i]["quantity"] *
                                              Temp.dine_in_cart[i]["price"]))
                                      as int;
                                  if (Temp.dine_in_cart[i]["category"] ==
                                      "YdpRfe1CwGZ4A3tgtYF9") {
                                    drinksOrderData.add({
                                      "label": Temp.dine_in_cart[i]["label"],
                                      "unitPrice": Temp.dine_in_cart[i]
                                          ["price"],
                                      "quantity": Temp.dine_in_cart[i]
                                          ["quantity"],
                                      "totalPrice": (Temp.dine_in_cart[i]
                                                  ["price"] *
                                              Temp.dine_in_cart[i]["quantity"])
                                          as int,
                                      "completedPercent": 0,
                                      "completedCount": 0,
                                      "category": Temp.dine_in_cart[i]
                                          ["category"],
                                      "state": "ORDERED",
                                    });
                                  } else {
                                    foodOrderData.add({
                                      "label": Temp.dine_in_cart[i]["label"],
                                      "unitPrice": Temp.dine_in_cart[i]
                                          ["price"],
                                      "quantity": Temp.dine_in_cart[i]
                                          ["quantity"],
                                      "totalPrice": (Temp.dine_in_cart[i]
                                                  ["price"] *
                                              Temp.dine_in_cart[i]["quantity"])
                                          as int,
                                      "completedPercent": 0,
                                      "completedCount": 0,
                                      "category": Temp.dine_in_cart[i]
                                          ["category"],
                                      "state": "ORDERED",
                                    });
                                  }
                                } else {
                                  for (int j = 0;
                                      j <
                                          Temp.dine_in_cart[i]["choices"]
                                              .length;
                                      j++) {
                                    total = (total +
                                            (Temp.dine_in_cart[i]["choices"][j]
                                                    ["quantity"] *
                                                Temp.dine_in_cart[i]["price"]))
                                        as int;
                                    if (Temp.dine_in_cart[i]["category"] ==
                                        "YdpRfe1CwGZ4A3tgtYF9") {
                                      drinksOrderData.add({
                                        "label": Temp.dine_in_cart[i]["choices"]
                                            [j]["choice"],
                                        "unitPrice": Temp.dine_in_cart[i]
                                            ["price"],
                                        "quantity": Temp.dine_in_cart[i]
                                            ["choices"][j]["quantity"],
                                        "totalPrice": (Temp.dine_in_cart[i]
                                                ["price"] *
                                            Temp.dine_in_cart[i]["choices"][j]
                                                ["quantity"]) as int,
                                        "completedPercent": 0,
                                        "completedCount": 0,
                                        "category": Temp.dine_in_cart[i]
                                            ["category"],
                                        "state": "ORDERED",
                                      });
                                    } else {
                                      foodOrderData.add({
                                        "label": Temp.dine_in_cart[i]["choices"]
                                            [j]["choice"],
                                        "unitPrice": Temp.dine_in_cart[i]
                                            ["price"],
                                        "quantity": Temp.dine_in_cart[i]
                                            ["choices"][j]["quantity"],
                                        "totalPrice": (Temp.dine_in_cart[i]
                                                ["price"] *
                                            Temp.dine_in_cart[i]["choices"][j]
                                                ["quantity"]) as int,
                                        "completedPercent": 0,
                                        "completedCount": 0,
                                        "category": Temp.dine_in_cart[i]
                                            ["category"],
                                        "state": "ORDERED",
                                      });
                                    }
                                  }
                                }
                              }

                              var orderData = {
                                "total": total,
                                "drinkOrder": drinksOrderData,
                                "foodORder": foodOrderData,
                                "completedPercent": 0,
                                "completedCount": 0,
                                "orderQuantity": quantityTotal,
                                "state": "ORDERED",
                                "tableNum": table_controller.text,
                                "customer": phone_controller.text,
                                "orderTime": DateTime.now()
                              };


                              FirebaseFirestore.instance.collection('order')
                                  .add(orderData)
                                  .then((value) => {
                                print("Order has been confirmed!"),
                              }).catchError((onError) => {
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Something went Wrong!'),
                                      content: Text(
                                          onError.toString()),
                                      actions: <Widget>[
                                        TextButton(
                                          style:
                                          TextButton.styleFrom(
                                            textStyle:
                                            Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          child: const Text('Okay'),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                )
                              });
                            },
                            icon: Icon(
                              Icons.save,
                              size: 24.0,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            label: const Text("C O N F I R M   O R D E R",
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255))),
                          ))),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
      const SizedBox(height: 50.0),
    ]);
  }
}
