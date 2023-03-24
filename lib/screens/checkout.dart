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
        body: Padding(
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
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Choose Table Number :",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  )),
            ),
            SizedBox(height: 10,),
            SizedBox(
                height: 35,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTable = Temp.availableTables[index];
                          });

                        },
                        child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        color: Temp.availableTables[index] == selectedTable?
                        Colors.green:Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child:
                         Padding(
                           padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                           child:
                           Text(
                             Temp.availableTables[index].toString(),
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               color: Temp.availableTables[index] == selectedTable?
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
            ),
            SizedBox(height: 15,),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Comments :",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  )),
            ),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'let the chef know ...\n\n',
              ),
            )
          ])),
        ));
  }
}
