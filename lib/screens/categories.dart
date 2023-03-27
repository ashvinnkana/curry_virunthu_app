import 'package:cached_network_image/cached_network_image.dart';
import 'package:curry_virunthu_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: buildCategoryList(context)),
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
                  Color.fromARGB(97, 147, 238, 122),
                  Color.fromARGB(255, 23, 141, 28),
                ]),
              ),
              padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 10),
              child: const Text(
                "L O A D I N G ...",
                textAlign: TextAlign.center,
              ));
        }
        return GridView.count(
          crossAxisCount: 2,
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> category =
                    document.data()! as Map<String, dynamic>;
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
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                                imageUrl: category["img"],
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      )),
                                    ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width),
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  // Add one stop for each color. Stops should increase from 0 to 1
                                  stops: [0.2, 0.7],
                                  colors: [
                                    Color.fromARGB(100, 52, 52, 52),
                                    Color.fromARGB(100, 52, 52, 52),
                                  ],
                                ),
                              ),
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.height,
                            ),
                            Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.height,
                                padding: const EdgeInsets.all(1),
                                // constraints: BoxConstraints(
                                //   minWidth: 20,
                                //   minHeight: 20,
                                // ),
                                child: Center(
                                  child: Text(
                                    category["label"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                );
              })
              .toList()
              .cast(),
        );
      },
    );
  }
}
