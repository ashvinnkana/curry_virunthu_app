import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/order_item.dart';

class MyOrder extends StatelessWidget {
  dynamic phoneNum = "";
  MyOrder() {
    phoneNum = FirebaseAuth.instance.currentUser?.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title:
        const Text("M Y   O R D E R S", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 123, 152, 60),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
              child: SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('order')
                          .where("customer", isEqualTo: FirebaseAuth.instance.currentUser?.phoneNumber)
                          .orderBy("orderTime" ,descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container();
                        }

                        var _list = snapshot.data!.docs;

                        if (_list.isNotEmpty) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> order =
                                document.data()! as Map<String, dynamic>;
                                String id = document.id;

                                return GestureDetector(
                                  child: Padding(
                                      padding: const EdgeInsets.only(right: 0.0),
                                      child: OrderItem(
                                          id: id,
                                          orderTime: order["orderTime"].toDate(),
                                          completedPercent: order["completedPercent"].round(),
                                          state: order["state"],
                                          orderType: order["orderType"],
                                          tableNum: order["tableNum"],
                                          total: order["total"],
                                          foodOrder: order["foodOrder"],
                                          drinkOrder: order["drinkOrder"]
                                      )),
                                  onTap: () {
                                  },
                                ) ;
                              })
                                  .toList()
                                  .cast(),
                            ),
                          );
                        } else {
                          return Container(
                              width: MediaQuery.of(context).size.width ,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: const LinearGradient(colors: [
                                  Color.fromARGB(255, 83, 129, 86),
                                  Color.fromARGB(255, 96, 171, 93),
                                ]),
                              ),
                              padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 10),
                              child: const Text(
                                "NO ORDERS YET",
                                textAlign: TextAlign.center,
                              ));
                        }


                      }))),
        ],
      ),
    );
  }
}
