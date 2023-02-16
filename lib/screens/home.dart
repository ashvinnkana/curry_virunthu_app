import 'package:curry_virunthu_app/screens/product_view.dart';
import 'package:curry_virunthu_app/widgets/product_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:curry_virunthu_app/screens/categories.dart';
import 'package:curry_virunthu_app/screens/trending.dart';
import 'package:curry_virunthu_app/widgets/category_item.dart';
import 'package:curry_virunthu_app/widgets/search_card.dart';
import 'package:curry_virunthu_app/widgets/slide_item.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: ListView(
            children: <Widget>[
              buildSearchBar(context),
              const SizedBox(height: 20.0),
              buildMenuHeadingRow(context),
              const SizedBox(height: 10.0),
              buildMenuList(context),
              const SizedBox(height: 10.0),
              buildTrendingHeadingRow(context),
              const SizedBox(height: 10.0),
              buildTrendingList(context),
              const SizedBox(height: 10.0),
              buildCategoriesHeadingRow(context),
              const SizedBox(height: 10.0),
              buildCategoryList(context),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  //MENU

  buildMenuHeadingRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          "Today's Menu",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        TextButton(
          child: Text(
            "See all",
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return MainScreen(1, "All");
                },
              ),
            );
          },
        ),
      ],
    );
  }

  buildMenuList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('item')
          .where("isAvailable", isEqualTo: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height / 6,
          child: ListView(
            primary: false,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> product =
                      document.data()! as Map<String, dynamic>;
                  String id = document.id;
                  return GestureDetector(
                    child: ProductItem(prod: product),
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
      },
    );
  }

  //SEARCH

  buildSearchBar(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 0), child: SearchCard());
  }

  //TRENDING

  buildTrendingHeadingRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          "Trending Dishes",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        TextButton(
          child: Text(
            "See all",
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return Trending();
                },
              ),
            );
          },
        ),
      ],
    );
  }

  buildTrendingList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('item')
          .orderBy("buyCount", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return Container(
          height: MediaQuery.of(context).size.height / 2.4,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            primary: false,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> trend =
                      document.data()! as Map<String, dynamic>;
                  String id = document.id;
                  return GestureDetector(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: SlideItem(
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
    );
  }

  //CATEGORY

  buildCategoriesHeadingRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          "Categories",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        TextButton(
          child: Text(
            "See all",
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return Categories();
                },
              ),
            );
          },
        ),
      ],
    );
  }

  buildCategoryList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('category')
          .orderBy("orderId")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return Container(
          height: MediaQuery.of(context).size.height / 6,
          child: ListView(
            primary: false,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> category =
                      document.data()! as Map<String, dynamic>;
                  String id = document.id;
                  return CategoryItem(cat: category);
                })
                .toList()
                .cast(),
          ),
        );
      },
    );
  }
}
