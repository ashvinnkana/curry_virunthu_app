import 'package:curry_virunthu_app/screens/product_view.dart';
import 'package:curry_virunthu_app/util/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/menu_item.dart';

class Menu extends StatelessWidget {

  Menu() {
    FirebaseFirestore.instance.collection("customer")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) => {
          CurrentUser.dine_in_cart = value["dineInCart"],
          print(value["dineInCart"])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("T O D A Y ' S   M E N U",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 123, 152, 60),
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
            child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('category')
                        .orderBy("orderId")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      return ListView(
                        primary: true,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                              Map<String, dynamic> category =
                                  document.data()! as Map<String, dynamic>;
                              String id = document.id;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  buildHeading(context, category["label"]),
                                  const SizedBox(height: 10.0),
                                  buildList(context, id),
                                  const SizedBox(height: 40.0),
                                ],
                              );
                            })
                            .toList()
                            .cast(),
                      );
                    }))));
  }

  buildHeading(BuildContext context, String category) {
    return Padding(
      padding: EdgeInsets.only(left: 0),
      child: Text(
        "${category.toUpperCase().trim().replaceAll("", " ")}",
        style: TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }

  buildList(BuildContext context, String categoryId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('item')
          .where("isAvailable", isEqualTo: true)
          .where("category", isEqualTo: categoryId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading ...");
        }

        var _list = snapshot.data!.docs;

        if (_list.isNotEmpty) {
          return Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> product =
                        document.data()! as Map<String, dynamic>;
                    String id = document.id;
                    return GestureDetector(
                      child: Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: MenuItems(
                              id: id,
                              img: product["img"],
                              title: product["label"],
                              desc: product["description"],
                              buyCount: product["buyCount"],
                              isAvailable: product["isAvailable"],
                              price: product["price"],
                              choices: product["choices"])),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return ProductView(product, id);
                            },
                          ),
                        );
                      },
                    );
                  })
                  .toList()
                  .cast(),
            ),
          );
        } else {
          return Container(
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(97, 238, 122, 122),
                  Color.fromARGB(255, 246, 82, 82),
                ]),
              ),
              padding: EdgeInsets.fromLTRB(20.0, 10, 20.0, 10),
              child: Text(
                "SOLD OUT",
                textAlign: TextAlign.center,
              ));
        }
      },
    );
  }
}
