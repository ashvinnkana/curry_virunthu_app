import 'package:curry_virunthu_app/util/temp.dart';
import 'package:curry_virunthu_app/util/user_session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/gradient_slide_to_act.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

import 'main_screen.dart';

class Checkout extends StatefulWidget {
  final List<dynamic> foodOrder;
  final List<dynamic> drinkOrder;
  final total;
  final quantityTotal;

  Checkout(
      {required this.foodOrder,
      required this.drinkOrder,
      required this.total,
      required this.quantityTotal}) {
    FirebaseFirestore.instance
        .collection('temp')
        .doc('settings')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        Temp.selfOrderUnlock = data["unlockSelfOrder"];
      }
    });
  }

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool loading = false;
  String loading_text = "C O N F I R M I N G   O R D E R";
  String choosenCheckout = "Dine-in";
  String choosenDelivery = "Pick-Up at Restaurant";
  var checkoutOptions = ["Dine-in", "Takeaway"];
  var deliveryOptions = ["Pick-Up at Restaurant"];
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController cusComment = TextEditingController();
  dynamic orderData = {};
  var selectedTable = null;

  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(2, "All")));
            },
          ),
          elevation: 0.0,
          title: Text("C H E C K O U T"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 123, 152, 60),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
              child: SingleChildScrollView(
                  child: Column(children: [
                Center(
                  child: Text("\$${widget.total.toString()}",
                      style: const TextStyle(
                        fontSize: 45,
                        color: Colors.orange,
                      )),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text("TOTAL",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Checkout Option :",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      )),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            isExpanded: true,
                            style: TextStyle(fontSize: 15, color: Colors.white),
                            value: choosenCheckout,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            items: checkoutOptions.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                choosenCheckout = newValue!;
                              });
                            }))),
                SizedBox(
                  height: 15,
                ),
                choosenCheckout == 'Takeaway'
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Delivery Method :",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            )),
                      )
                    : SizedBox(),
                choosenCheckout == 'Takeaway'
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                isExpanded: true,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                                value: choosenDelivery,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                                items: deliveryOptions.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Row(
                                      children: [
                                        Text(
                                          items,
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    choosenDelivery = newValue!;
                                  });
                                })))
                    : SizedBox(),
                choosenCheckout == 'Takeaway'
                    ? SizedBox(
                        height: 15,
                      )
                    : SizedBox(),
                Temp.selfOrderUnlock ||
                        Session.userData["admin"] ||
                        choosenCheckout == 'Takeaway'
                    ? Column(
                        children: <Widget>[
                          choosenCheckout == "Dine-in"
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Choose Table Number :",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      )),
                                )
                              : SizedBox(),
                          choosenCheckout == "Dine-in"
                              ? SizedBox(
                                  height: 10,
                                )
                              : SizedBox(),
                          choosenCheckout == "Dine-in"
                              ? SizedBox(
                                  height: 35,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: ClampingScrollPhysics(),
                                    itemBuilder: (_, index) {
                                      return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedTable = Temp
                                                  .availableTables[index]
                                                      ["tableNum"]
                                                  .toString();
                                              if (Temp.availableTables[index]
                                                      ["state"] ==
                                                  "OCCUPIED") {
                                                phoneNumController.text = Temp
                                                    .availableTables[index]
                                                        ["customer"]
                                                    .toString()
                                                    .replaceAll("+61", "");
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Temp.availableTables[index]
                                                              ["tableNum"]
                                                          .toString() ==
                                                      selectedTable
                                                  ? Colors.green
                                                  : Temp.availableTables[index]
                                                              ["state"] ==
                                                          "OCCUPIED"
                                                      ? Color.fromRGBO(
                                                          86, 4, 4, 1.0)
                                                      : Colors.black,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 10, 0, 10),
                                              child: Text(
                                                Temp.availableTables[index]
                                                        ["tableNum"]
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Temp.availableTables[
                                                                    index]
                                                                    ["tableNum"]
                                                                .toString() ==
                                                            selectedTable
                                                        ? Colors.black
                                                        : Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ));
                                    },
                                    itemCount: Temp.availableTables.length,
                                    separatorBuilder: (_, index) {
                                      return SizedBox(
                                        width: 5,
                                      );
                                    },
                                  ))
                              : SizedBox(),
                          choosenCheckout == "Dine-in"
                              ? SizedBox(
                                  height: 10,
                                )
                              : SizedBox(),
                          choosenCheckout == "Dine-in"
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "Already occupied tables are highlighted in RED!",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.blueAccent,
                                      )),
                                )
                              : SizedBox(),
                          choosenCheckout == "Dine-in"
                              ? SizedBox(
                                  height: 20,
                                )
                              : SizedBox(),
                          Session.userData["admin"]
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Customer PhoneNumber :",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      )),
                                )
                              : SizedBox(),
                          Session.userData["admin"]
                              ? SizedBox(
                                  height: 10,
                                )
                              : SizedBox(),
                          Session.userData["admin"]
                              ? Container(
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [
                                        0.2,
                                        0.7
                                      ],
                                          colors: [
                                        Color.fromARGB(255, 40, 40, 40),
                                        Color.fromARGB(255, 40, 40, 40),
                                      ])),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: 10.0,
                                          bottom: 10.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            _emoji(),
                                            style:
                                                const TextStyle(fontSize: 25),
                                          ),
                                          const Text(
                                            "  +61     ",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: TextField(
                                                controller: phoneNumController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: "Phone Number",
                                                  hintText: "41 655 1457",
                                                ),
                                                onChanged: (text) => {
                                                  setState(() {
                                                    if (text.length == 9) {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    }
                                                  })
                                                },
                                              ))
                                        ],
                                      )),
                                )
                              : SizedBox(),
                          Session.userData["admin"]
                              ? const SizedBox(height: 10.0)
                              : SizedBox(),
                          Session.userData["admin"]
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 0.0),
                                  child: (phoneNumController.text.length != 9 &&
                                          phoneNumController.text.isNotEmpty
                                      ? Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                              "Valid Phone Number Required!",
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.red,
                                              )),
                                        )
                                      : const SizedBox()))
                              : SizedBox(),
                          Session.userData["admin"]
                              ? SizedBox(
                                  height: 10,
                                )
                              : SizedBox(),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Comments :",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: cusComment,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'let the chef know ...\n\n',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          checkAllFields()
                              ? (choosenCheckout == "Dine-in"
                                  ? GradientSlideToAct(
                                      text: "CONFIRM ORDER",
                                      width: 400,
                                      dragableIconBackgroundColor:
                                          Color.fromARGB(255, 148, 182, 117),
                                      textStyle: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                      backgroundColor:
                                          Color.fromARGB(255, 148, 182, 117),
                                      onSubmit: () {
                                        /////////////////////////////////////

                                        String? customer_num = "";
                                        if (Session.userData["admin"]) {
                                          customer_num =
                                              "+61" + phoneNumController.text;
                                        } else {
                                          customer_num = FirebaseAuth.instance
                                              .currentUser?.phoneNumber;
                                        }

                                        if (choosenCheckout == "Dine-in") {
                                          orderData = {
                                            "total": widget.total,
                                            "drinkOrder": widget.drinkOrder,
                                            "foodOrder": widget.foodOrder,
                                            "completedPercent": 0,
                                            "completedCount": 0,
                                            "orderQuantity":
                                                widget.quantityTotal,
                                            "state": "ORDERED",
                                            "tableNum": selectedTable,
                                            "customer": customer_num,
                                            "orderTime": DateTime.now(),
                                            "orderType": choosenCheckout,
                                            "comment": cusComment.text
                                          };
                                          FirebaseFirestore.instance
                                              .collection("tableData")
                                              .doc(selectedTable)
                                              .update({
                                            "state": "OCCUPIED",
                                            "customer": customer_num
                                          }).then((value) => {});
                                        } else {
                                          orderData = {
                                            "total": widget.total,
                                            "drinkOrder": widget.drinkOrder,
                                            "foodOrder": widget.foodOrder,
                                            "completedPercent": 0,
                                            "completedCount": 0,
                                            "orderQuantity":
                                                widget.quantityTotal,
                                            "state": "ORDERED",
                                            "customer": FirebaseAuth.instance
                                                .currentUser?.phoneNumber,
                                            "orderTime": DateTime.now(),
                                            "orderType": choosenCheckout,
                                            "comment": cusComment.text
                                          };
                                        }

                                        Temp.dine_in_cart = [];
                                        FirebaseFirestore.instance
                                            .collection('order')
                                            .add(orderData)
                                            .then((value) => {
                                                  FirebaseFirestore.instance
                                                      .collection("customer")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser?.uid)
                                                      .update({
                                                        "dineInCart":
                                                            Temp.dine_in_cart
                                                      })
                                                      .then((value) => {
                                                            print(
                                                                "Cart Updated"),
                                                            cusComment.text =
                                                                "",
                                                            selectedTable =
                                                                null,
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  print(Temp
                                                                      .availableTables
                                                                      .length);
                                                                  return MainScreen(
                                                                      2, "All");
                                                                },
                                                              ),
                                                            )
                                                          })
                                                      .catchError((error) => print(
                                                          "Failed to update cart: $error"))
                                                })
                                            .catchError((onError) => {
                                                  showDialog<void>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Something went Wrong!'),
                                                        content: Text(
                                                            onError.toString()),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            style: TextButton
                                                                .styleFrom(
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .labelLarge,
                                                            ),
                                                            child: const Text(
                                                                'Okay'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  )
                                                });
                                      },
                                      gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0Xff11998E),
                                            Color(0Xff38EF7D),
                                          ]),
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          loading = true;
                                        });
                                        await makePayment();
                                      },
                                      child: Text('Proceed to Payment'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.lightGreen.shade800,
                                      ),
                                    ))
                              : Text(
                                  "All Fields Required!",
                                  style: TextStyle(color: Colors.red),
                                ),
                        ],
                      )
                    : Text(
                        "Contact a staff to complete proceeding with your order! ",
                        style: TextStyle(color: Colors.red),
                      ),
              ])),
            ),
            getLoadingScreen()
          ],
        ));
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(widget.total.toString(), 'AUD');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  //applePay: const PaymentSheetApplePay(merchantCountryCode: '+61',),
                  //googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "AU", merchantCountryCode: "+61"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Curry Virunthu'))
          .then((value) {});
      displayPaymentSheet();
    } catch (e, s) {
      setState(() {
        loading = false;
      });
      print('exception:$e$s');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.warning_amber,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text("Payment Failed!"),
                      ],
                    ),
                  ],
                ),
              ));
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text("Payment Successfull!"),
                        ],
                      ),
                    ],
                  ),
                ));
        orderData = {
          "total": widget.total,
          "drinkOrder": widget.drinkOrder,
          "foodOrder": widget.foodOrder,
          "completedPercent": 0,
          "completedCount": 0,
          "orderQuantity": widget.quantityTotal,
          "state": "ORDERED",
          "customer": FirebaseAuth.instance.currentUser?.phoneNumber,
          "orderTime": DateTime.now(),
          "orderType": choosenCheckout,
          "comment": cusComment.text
        };

        Temp.dine_in_cart = [];
        FirebaseFirestore.instance
            .collection('order')
            .add(orderData)
            .then((value) => {
                  FirebaseFirestore.instance
                      .collection("customer")
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .update({"dineInCart": Temp.dine_in_cart})
                      .then((value) => {
                            print("Cart Updated"),
                            cusComment.text = "",
                            selectedTable = null,
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  print(Temp.availableTables.length);
                                  return MainScreen(2, "All");
                                },
                              ),
                            )
                          })
                      .catchError(
                          (error) => print("Failed to update cart: $error"))
                })
            .catchError((onError) => {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Something went Wrong!'),
                        content: Text(onError.toString()),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Okay'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  )
                });
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        setState(() {
          loading = false;
        });
        print('Error is:--->$error $stackTrace');
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.warning_amber,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text("Payment Failed!"),
                        ],
                      ),
                    ],
                  ),
                ));
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${Temp.STRIPE_SECRET_KEY}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  checkAllFields() {
    if (Session.userData["admin"] && phoneNumController.text.length != 9) {
      return false;
    }

    if (choosenCheckout == "Dine-in" && selectedTable == null) {
      return false;
    }

    return true;
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
              top: 10,
              left: MediaQuery.of(context).size.width / 4,
              child: Image.asset(
                "assets/loading.gif",
                width: MediaQuery.of(context).size.width / 2,
              )),
          Positioned(
              top: 160,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "$loading_text\n. . .",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )))
        ],
      );
    } else {
      return Container();
    }
  }

  String _emoji() {
    int flagOffset = 0x1F1E6;
    int asciiOffset = 0x41;

    String country = "AU";

    int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
    int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;

    String emoji =
        String.fromCharCode(firstChar) + String.fromCharCode(secondChar);

    return emoji;
  }
}
