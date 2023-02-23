import 'package:curry_virunthu_app/screens/product_view.dart';
import 'package:curry_virunthu_app/util/temp.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import '../widgets/menu_item.dart';

class Menu extends StatefulWidget {
  late String choosen_category;

  Menu(this.choosen_category);

  @override
  _MenuState createState() => _MenuState(choosen_category);
}

class _MenuState extends State<Menu> {

  late String choosen_category;
  bool loading = false;

  _MenuState(this.choosen_category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
        Padding(
        padding: const EdgeInsets.only( right:20, top: 10, bottom: 10),
      child:
      DecoratedBox(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 0, 0, 1.0),
                    Color.fromRGBO(0, 0, 0, 1.0),
                    //add more colors
                  ]),
              borderRadius: BorderRadius.circular(5),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                    blurRadius: 2) //blur radius of shadow
              ]
          ),
          child: Padding(
              padding: const EdgeInsets.only(left:10, right:10),
              child:DropdownButton(
                underline: Container(), //empty line
                style: const TextStyle(fontSize: 12, color: Colors.white),
                dropdownColor: Colors.black,
                iconEnabledColor: Colors.white, //Icon color
                value: choosen_category,
                items: Temp.categoryLabels.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                icon: const Icon(Icons.keyboard_arrow_down),
                onChanged: (String? newValue) {
                  setState(() {
                    choosen_category = newValue!;
                  });
                },)
          )
      )

            )
          ],
          automaticallyImplyLeading: false,
          title: const Text("T O D A Y ' S   M E N U",
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 123, 152, 60),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
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
                            return Container();
                          }

                          return ListView(
                            primary: true,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> category =
                              document.data()! as Map<String, dynamic>;
                              String id = document.id;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  (choosen_category == "All") ?
                                  buildHeading(context, category["label"]):
                                  Container(),
                                  (choosen_category == "All" || choosen_category == category["label"]) ?
                                  buildList(context, id) : Container(),

                                ],
                              );
                            })
                                .toList()
                                .cast(),
                          );
                        }))),
            getLoadingScreen()
          ],
        )
    );
  }


  @override
  void initState() {
    super.initState();
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
                    "L O A D I N G\n. . .",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )))
        ],
      );
    } else {
      return Container();
    }
  }

  buildHeading(BuildContext context, String category) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            category.toUpperCase().trim().replaceAll("", " "),
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),const SizedBox(height: 10.0)
      ],
    );

  }

  buildList(BuildContext context, String categoryId) {
    return Column(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
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
              return Container();
            }

            var _list = snapshot.data!.docs;

            if (_list.isNotEmpty) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                    Map<String, dynamic> product =
                    document.data()! as Map<String, dynamic>;
                    String id = document.id;
                    return Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: MenuItems(
                              id: id,
                              img: product["img"],
                              title: product["label"],
                              desc: product["description"],
                              buyCount: product["buyCount"],
                              isAvailable: product["isAvailable"],
                              price: product["price"],
                              choices: product["choices"],
                            category : categoryId,
                            data: product
                          ));
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
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(97, 238, 122, 122),
                      Color.fromARGB(255, 246, 82, 82),
                    ]),
                  ),
                  padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 10),
                  child: const Text(
                    "SOLD OUT",
                    textAlign: TextAlign.center,
                  ));
            }
          },
        ),
        const SizedBox(height: 40.0)
      ],
    );

  }
}
