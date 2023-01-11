import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Categories'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: buildCategoryList(context)
      ),
    );
  }

  buildCategoryList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('category')
          .orderBy("orderId")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        return GridView.count(
            crossAxisCount: 2,
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
            Map<String, dynamic> category =
            document.data()! as Map<String, dynamic>;
            return Container(
              padding: EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  children: <Widget>[
                    Image.network(
                      category['img'],
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
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
                )
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
