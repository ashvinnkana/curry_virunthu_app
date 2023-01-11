import 'package:flutter/material.dart';
import 'package:curry_virunthu_app/util/items.dart';
import 'package:curry_virunthu_app/widgets/search_card.dart';
import 'package:curry_virunthu_app/widgets/trending_item.dart';

class Trending extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Trending Restaurants"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 10.0,
        ),
        child: ListView(
          children: <Widget>[
            SearchCard(),
            SizedBox(height: 10.0),
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items == null ? 0 : items.length,
              itemBuilder: (BuildContext context, int index) {
                Map restaurant = items[index];

                return TrendingItem(
                  img: restaurant["img"],
                  title: restaurant["title"],
                  desc: restaurant["address"],
                  buyCount: restaurant["rating"],
                  price: restaurant["rating"],
                  isAvailable: true,
                );
              },
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
