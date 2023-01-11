
import 'package:flutter/material.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:flutter/services.dart';
import '../widgets/gradient_slide_to_act.dart';
import 'add_to_cart.dart';

class ProductView extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductView(this.product);

  @override
  _ProductViewState createState() => _ProductViewState(product);
}

class _ProductViewState extends State<ProductView> {

  final Map<String, dynamic> product;
  int currentChoice = 0;
  dynamic  quantity = 1;

  _ProductViewState(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(product['label']),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              Stack(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        "${product["img"]}",
                        fit: BoxFit.cover,
                      )
                  ),
                  Positioned(
                    bottom: 6.0,
                    right: 6.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.favorite,
                              color: Colors.pink,
                              size: 15,
                            ),
                            Text(
                              " ${product["buyCount"]} ",
                              style: const TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20.0),
              const Padding(
                  padding:  EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Price",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
              const SizedBox(height: 5.0),
              Padding(
                  padding:  const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "A\$ ${product["price"]}",
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreenAccent
                    ),
                  )
              ),
              const SizedBox(height: 20.0),
              Padding(
                  padding:  const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "${product["description"]}",
                    style: const TextStyle(
                        fontSize: 15
                    ),
                  )
              ),
              const SizedBox(height: 20.0),
              const Divider(
                  color: Colors.white
              ),
              const SizedBox(height: 20.0),
              const Padding(
                  padding:  EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Pick your choice",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreen
                    ),
                  )
              ),
              const SizedBox(height: 10.0),
              Padding(
                  padding:  const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: listItemChoice()
              ),
              const SizedBox(height: 20.0),
              const Padding(
                  padding:  EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Quantity",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreen
                    ),
                  )
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QuantityInput(
                      value: quantity,
                      onChanged: (value) => setState(() => quantity = int.parse(value.replaceAll(',', ''))),
                    minValue: 1,
                    buttonColor: Color.fromARGB(255, 68, 67, 67),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Padding(
                  padding:  const EdgeInsets.only(left: 70.0, right: 70.0),
                  child: GradientSlideToAct(
                    width: 400,
                    dragableIconBackgroundColor: Colors.lightGreenAccent,
                    textStyle: TextStyle(color: Colors.white,fontSize: 15),
                    backgroundColor: Colors.lightGreen,
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
                  ),
              ),

              const SizedBox(height: 20.0),
            ],
          )
      ),
    );
  }

  listItemChoice() {
    return ListView.separated(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder:(_, index) {
          if (product["choices"][index]["isAvailable"]) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                    value: index,
                    groupValue: currentChoice,
                    onChanged: (flag) {
                      setState(() {
                        currentChoice = index;
                      });
                    }
                ),
                Expanded(
                  child: Text(
                    product["choices"][index]["label"].toString(),
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(left: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      product["choices"][index]["isVeg"] == true
                          ? 'VEG'
                          : "NON-VEG",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: product["choices"][index]["isVeg"] == true
                            ? Colors.lightGreenAccent
                            : Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                    padding:  EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Text(
                      "SOLD OUT",
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.red
                      ),
                    ),
                ),
                Expanded(
                  child: Text(
                    product["choices"][index]["label"].toString(),
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(left: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      product["choices"][index]["isVeg"] == true
                          ? 'VEG'
                          : "NON-VEG",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: product["choices"][index]["isVeg"] == true
                            ? Colors.lightGreen
                            : Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        },
        itemCount: product["choices"].length,
        separatorBuilder: (_, index) {
          return SizedBox(height: 5,);
        },);
  }

}
