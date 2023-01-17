import 'package:curry_virunthu_app/util/user.dart';
import 'package:curry_virunthu_app/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/gradient_slide_to_act.dart';
import 'add_to_cart.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("M Y  C A R T",
              style: TextStyle(
                  color: Colors.white
              )
          ),
          backgroundColor: Color.fromARGB(255, 123, 152, 60),
        ),
      body: SingleChildScrollView(child:Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
    child: User.dine_in_cart.length == 0 ?
      buildEmptyCart(context) :
      buildListCart(context)))
    );
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

  findTotal() {
    int total = 0;
    for (int i = 0; i < User.dine_in_cart.length; i++) {
      if (User.dine_in_cart[i]["choices"] == null) {
        total = (total + (User.dine_in_cart[i]["quantity"] * User.dine_in_cart[i]["price"])) as int;
      } else {
        for (int j = 0; j < User.dine_in_cart[i]["choices"].length; j++) {
          total = (total + (User.dine_in_cart[i]["choices"][j]["quantity"] * User.dine_in_cart[i]["price"])) as int;
        }
      }
    }
    return total;
  }

  buildListCart(BuildContext context) {
    return Column(
        children: <Widget>[
          Container(
        child: Center(
          child: ListView.separated(
              primary: false,
              shrinkWrap: true,
            itemCount: User.dine_in_cart.length,
            physics: ClampingScrollPhysics(),
            itemBuilder:(_, index) {
              return Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: User.dine_in_cart[index]["choices"] == null ?
                  CartItem(
                      price: User.dine_in_cart[index]["price"],
                      itemid: User.dine_in_cart[index]["itemid"],
                      label: User.dine_in_cart[index]["label"],
                      quantity: User.dine_in_cart[index]["quantity"]):
                  ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: User.dine_in_cart[index]["choices"].length,
                      physics: ClampingScrollPhysics(),
                      itemBuilder:(_, index2) {
                        return CartItem(
                                price: User.dine_in_cart[index]["price"],
                                itemid: User.dine_in_cart[index]["itemid"],
                                label: User.dine_in_cart[index]["choices"][index2]["choice"],
                                quantity: User.dine_in_cart[index]["choices"][index2]["quantity"]);

                      },
                      separatorBuilder: (_, index) {
                        return SizedBox(height: 5,);
                      }
                  )
              );
            },
            separatorBuilder: (_, index) {
              return SizedBox(height: 5,);
            }
          )
        )
    ),
          const SizedBox(height: 10.0),
    Padding(
    padding: EdgeInsets.only(left: 85.0, right: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("T O T A L",
              style: TextStyle(
                fontSize: 15,
                color: Colors.lightBlue
              ),),
              Text("\$${findTotal().toString()}",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.lightBlue
                  )),

            ],
          )
    ),
          const SizedBox(height: 10.0),
          Padding(
          padding: EdgeInsets.only(left: 85.0, right: 30.0),
    child:Divider(
            color: Colors.lightBlue,
          )),
          const SizedBox(height: 40.0),
          Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child:GradientSlideToAct(
            text: "PROCEED TO CHECKOUT",
            width: 400,
            dragableIconBackgroundColor: Color.fromARGB(255, 148, 182, 117),
            textStyle: TextStyle(color: Colors.black,fontSize: 15),
            backgroundColor: Color.fromARGB(255, 148, 182, 117),
            onSubmit: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    HapticFeedback.heavyImpact();
                    SystemSound.play(SystemSoundType.click);

                    return AddToCart();
                  },
                ),
              );
            },
            gradient:  const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0Xff11998E),
                  Color(0Xff38EF7D),
                ]
            ),
          )),
          const SizedBox(height: 50.0),
        ]);
  }


}
