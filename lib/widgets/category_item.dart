import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryItem extends StatelessWidget {
  final Map cat;

  CategoryItem({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: cat["img"],
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                )),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.height / 6,
            ),
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
                  // stops: [0.0, 0.1],
                ),
              ),
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.height / 6,
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 6,
                width: MediaQuery.of(context).size.height / 6,
                padding: const EdgeInsets.all(1),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Center(
                  child: Text(
                    cat["label"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
