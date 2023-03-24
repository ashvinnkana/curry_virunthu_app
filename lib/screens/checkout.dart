import 'package:curry_virunthu_app/util/temp.dart';
import 'package:flutter/material.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:flutter/services.dart';
import '../widgets/gradient_slide_to_act.dart';
import 'add_to_cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main_screen.dart';

class Checkout extends StatefulWidget {
  final List<dynamic> foodOrder;
  final List<dynamic> drinkOrder;
  final total;

  Checkout(
      {required this.foodOrder, required this.drinkOrder, required this.total});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool loading = false;
  String choosenCheckout = "Dine-in";
  var checkoutOptions = ["Dine-in", "Takeaway"];
  var selectedTable = null;
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
                    choosenCheckout=="Dine-in"? Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Choose Table Number :",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          )),
                    ): SizedBox(),
                    choosenCheckout=="Dine-in"?SizedBox(
                      height: 10,
                    ): SizedBox(),
                    choosenCheckout=="Dine-in"?SizedBox(
                        height: 35,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (_, index) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTable = Temp.availableTables[index]["tableNum"].toString();
                                  });

                                },
                                child: Container(
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Temp.availableTables[index]["tableNum"].toString() == selectedTable?Colors.green:
                                    Temp.availableTables[index]["state"]=="OCCUPIED"? Color.fromRGBO(
                                        86, 4, 4, 1.0): Colors.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                  child:
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child:
                                    Text(
                                      Temp.availableTables[index]["tableNum"].toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Temp.availableTables[index]["tableNum"].toString() == selectedTable?
                                          Colors.black:Colors.grey,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  )
                                  ,
                                ));
                          },
                          itemCount: Temp.availableTables.length,
                          separatorBuilder: (_, index) {
                            return SizedBox(
                              width: 5,
                            );
                          },
                        )
                    ): SizedBox(),
                    choosenCheckout=="Dine-in"?SizedBox(
                      height: 10,
                    ): SizedBox(),
                    choosenCheckout=="Dine-in"?Align(
                      alignment: Alignment.centerRight,
                      child: Text("Already occupied tables are highlighted in RED!",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                          )),
                    ): SizedBox(),
                    choosenCheckout=="Dine-in"?SizedBox(
                      height: 20,
                    ): SizedBox(),
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'let the chef know ...\n\n',
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GradientSlideToAct(
                      text: "CONFIRM ORDER",
                      width: 400,
                      dragableIconBackgroundColor:
                      Color.fromARGB(255, 148, 182, 117),
                      textStyle: TextStyle(color: Colors.black, fontSize: 15),
                      backgroundColor: Color.fromARGB(255, 148, 182, 117),
                      onSubmit: (){

                        /////////////////////////////////////
                        
                      },
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0Xff11998E),
                            Color(0Xff38EF7D),
                          ]),
                    ),

                  ])),
            ),
            getLoadingScreen()
          ],
        ) );
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
}
