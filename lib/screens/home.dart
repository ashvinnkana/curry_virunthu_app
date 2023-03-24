import 'dart:io';

import 'package:curry_virunthu_app/screens/product_view.dart';
import 'package:curry_virunthu_app/util/temp.dart';
import 'package:curry_virunthu_app/widgets/product_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:curry_virunthu_app/screens/categories.dart';
import 'package:curry_virunthu_app/screens/trending.dart';
import 'package:curry_virunthu_app/widgets/category_item.dart';
import 'package:curry_virunthu_app/widgets/slide_item.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main_screen.dart';

class Home extends StatefulWidget {
  Home() {
    FirebaseFirestore.instance
        .collection('item')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> item = doc.data() as Map<String, dynamic>;
        if (item["label"] != null) {
          Temp.items.add(item["label"]);
          Temp.itemDatas[item["label"]] = item;
        }
      });
    }).catchError((e) {
      print(e.message);
    });
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late bool refresh = false;
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
          body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: SizedBox(height: 35.0),
          ),
          GestureDetector(
            onTap: () {
              if (!refresh) {
                print("sfsdfsdfdsf");
                setState(() {
                  refresh = true;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: buildSearchBar(context),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
            child: ListView(
              padding: EdgeInsets.zero,
              primary: true,
              shrinkWrap: true,
              children: <Widget>[
                buildMenuHeadingRow(context),
                const SizedBox(height: 10.0),
                buildMenuList(context),
                const SizedBox(height: 10.0),
                buildGroceryHeadingRow(context),
                const SizedBox(height: 10.0),
                buildGroceryList(context),
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
          )),
        ],
      )),
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

  buildGroceryHeadingRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          "Mini Market",
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
                  return MainScreen(1, "Grocery");
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
          .where("category", isNotEqualTo: "zMyEDUtUyDBHPFfERBBD")
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

  buildGroceryList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('item')
          .where("category", isEqualTo: "zMyEDUtUyDBHPFfERBBD")
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

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  buildSearchBar(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Card(
          elevation: 6.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    Center(
                        child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Search',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        items: Temp.items
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                            print(Temp.itemDatas[value]);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ProductView(Temp.itemDatas[value],
                                      Temp.itemDatas[value]["id"]);
                                },
                              ),
                            );
                          });
                        },
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            textEditingController.clear();
                          }
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 300,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchMatchFn: (item, searchValue) {
                            return (item.value
                                .toString()
                                .toLowerCase()
                                .contains(searchValue.toLowerCase()));
                          },
                          searchController: textEditingController,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: textEditingController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Search for an item...',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //This to clear the search value when you close the menu
                      ),
                    )),
                  ],
                )),
          ),
        ));
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
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return MainScreen(1, category["label"]);
                            },
                          ),
                        );
                      },
                      child: CategoryItem(cat: category));
                })
                .toList()
                .cast(),
          ),
        );
      },
    );
  }
}
