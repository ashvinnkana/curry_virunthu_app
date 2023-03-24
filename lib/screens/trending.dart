import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curry_virunthu_app/screens/product_view.dart';
import 'package:flutter/material.dart';
import 'package:curry_virunthu_app/util/items.dart';
import 'package:curry_virunthu_app/widgets/trending_item.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/slide_item.dart';

class Trending extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Trending Dishes"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 10.0,
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('item')
              .orderBy("buyCount", descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            return Container(
              child: ListView(
                primary: false,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      Map<String, dynamic> trend =
                          document.data()! as Map<String, dynamic>;
                      String id = document.id;
                      return GestureDetector(
                        child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: TrendingItem(
                              img: trend["img"],
                              title: trend["label"],
                              desc: trend["description"],
                              buyCount: trend["buyCount"],
                              isAvailable: trend["isAvailable"],
                              price: trend["price"],
                            )),
                        onTap: () {
                          if (trend["isAvailable"]) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ProductView(trend, id);
                                },
                              ),
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: "Sorry, This item is sold out",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.lightGreenAccent,
                                textColor: Colors.black,
                                fontSize: 16.0);
                          }
                        },
                      );
                    })
                    .toList()
                    .cast(),
              ),
            );
          },
        ),
      ),
    );
  }
}
