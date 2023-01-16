import 'package:curry_virunthu_app/util/user.dart';
import 'package:curry_virunthu_app/widgets/cart_item.dart';
import 'package:flutter/material.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return User.dine_in_cart.length == 0 ?
      buildEmptyCart(context) :
        buildListCart(context);
  }

  buildEmptyCart(BuildContext context) {
    return Container(
        child: Center(
          child: Image.asset(
            "assets/empty_cart.png",
            height: MediaQuery.of(context).size.height/3,
            width: MediaQuery.of(context).size.height/3,
          ),
        )
    );
  }

  buildListCart(BuildContext context) {
    return Container(
        child: Center(
          child: ListView.separated(
            itemCount: User.dine_in_cart.length,
            physics: ClampingScrollPhysics(),
            itemBuilder:(_, index) {
              return CartItem(
                  img: User.dine_in_cart[index]["img"],
                  price: User.dine_in_cart[index]["price"],
                  itemid: User.dine_in_cart[index]["itemid"],
                  choices: User.dine_in_cart[index]["choices"]);
            },
            separatorBuilder: (_, index) {
              return SizedBox(height: 5,);
            }
          )
        )
    );
  }
}
