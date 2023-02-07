import 'package:curry_virunthu_app/screens/checkout.dart';
import 'package:curry_virunthu_app/util/user.dart';
import 'package:curry_virunthu_app/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/gradient_slide_to_act.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title:
              const Text("M Y  C A R T", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 123, 152, 60),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                child: CurrentUser.dine_in_cart.isEmpty
                    ? buildEmptyCart(context)
                    : buildListCart(context))));
  }

  buildEmptyCart(BuildContext context) {
    return Center(
      child: Image.asset(
    "assets/empty_cart.png",
    height: MediaQuery.of(context).size.height / 3,
    width: MediaQuery.of(context).size.height / 3,
      ),
    );
  }

  findTotal() {
    int total = 0;
    for (int i = 0; i < CurrentUser.dine_in_cart.length; i++) {
      if (CurrentUser.dine_in_cart[i]["choices"] == null) {
        total = (total +
            (CurrentUser.dine_in_cart[i]["quantity"] *
                CurrentUser.dine_in_cart[i]["price"])) as int;
      } else {
        for (int j = 0; j < CurrentUser.dine_in_cart[i]["choices"].length; j++) {
          total = (total +
              (CurrentUser.dine_in_cart[i]["choices"][j]["quantity"] *
                  CurrentUser.dine_in_cart[i]["price"])) as int;
        }
      }
    }
    return total;
  }

  buildListCart(BuildContext context) {
    return Column(children: <Widget>[
      Center(
          child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: CurrentUser.dine_in_cart.length,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (_, index) {
                return Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: CurrentUser.dine_in_cart[index]["choices"] == null
                        ? CartItem(
                            price: CurrentUser.dine_in_cart[index]["price"],
                            itemid: CurrentUser.dine_in_cart[index]["itemid"],
                            label: CurrentUser.dine_in_cart[index]["label"],
                            quantity: CurrentUser.dine_in_cart[index]["quantity"])
                        : ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemCount:
                                CurrentUser.dine_in_cart[index]["choices"].length,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (_, index2) {
                              return CartItem(
                                  price: CurrentUser.dine_in_cart[index]["price"],
                                  itemid: CurrentUser.dine_in_cart[index]
                                      ["itemid"],
                                  label: CurrentUser.dine_in_cart[index]["choices"]
                                      [index2]["choice"],
                                  quantity: CurrentUser.dine_in_cart[index]
                                      ["choices"][index2]["quantity"]);
                            },
                            separatorBuilder: (_, index) {
                              return const SizedBox(
                                height: 5,
                              );
                            }));
              },
              separatorBuilder: (_, index) {
                return const SizedBox(
                  height: 5,
                );
              })),
      const SizedBox(height: 10.0),
      Padding(
          padding: const EdgeInsets.only(left: 85.0, right: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                "T O T A L",
                style: TextStyle(fontSize: 15, color: Colors.lightBlue),
              ),
              Text("\$${findTotal().toString()}",
                  style: const TextStyle(fontSize: 25, color: Colors.lightBlue)),
            ],
          )),
      const SizedBox(height: 10.0),
      const Padding(
          padding: EdgeInsets.only(left: 85.0, right: 30.0),
          child: Divider(
            color: Colors.lightBlue,
          )),
      const SizedBox(height: 40.0),
      Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: GradientSlideToAct(
            text: "PROCEED TO DINE-IN",
            width: 400,
            dragableIconBackgroundColor: const Color.fromARGB(255, 227, 202, 41),
            textStyle: const TextStyle(color: Colors.black, fontSize: 15),
            backgroundColor: const Color.fromARGB(255, 227, 202, 41),
            onSubmit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    HapticFeedback.heavyImpact();
                    SystemSound.play(SystemSoundType.click);

                    return Checkout(findTotal());
                  },
                ),
              );
            },
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0Xff11998E),
                  Color(0Xff38EF7D),
                ]),
          )),
      const SizedBox(height: 10.0),
      Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: GradientSlideToAct(
            text: "PROCEED TO TAKE AWAY",
            width: 400,
            dragableIconBackgroundColor: const Color.fromARGB(
                255, 227, 111, 111),
            textStyle: const TextStyle(color: Colors.black, fontSize: 15),
            backgroundColor: const Color.fromARGB(
    255, 227, 111, 111),
            onSubmit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    HapticFeedback.heavyImpact();
                    SystemSound.play(SystemSoundType.click);

                    return Checkout(findTotal());
                  },
                ),
              );
            },
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0Xff11998E),
                  Color(0Xff38EF7D),
                ]),
          )),
      const SizedBox(height: 50.0),
    ]);
  }
}
