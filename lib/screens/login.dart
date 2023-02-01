import 'dart:ffi';

import 'package:curry_virunthu_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter/services.dart';
import '../widgets/gradient_slide_to_act.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ImageSlideshow(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.8,
                initialPage: 0,
                indicatorColor: Colors.blue,
                indicatorBackgroundColor: Colors.grey,
                onPageChanged: (value) {
                },
                autoPlayInterval: 4000,
                isLoop: true,
                children: [
                  Image.asset(
                      'assets/bg/bg1.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/bg/bg2.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/bg/bg3.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/bg/bg4.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/bg/bg6.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/bg/bg7.png',
                      fit: BoxFit.cover
                  ),
                ],
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.2, 0.7],
                    colors: [
                      Color.fromARGB(100, 52, 52, 52),
                      Color.fromARGB(200, 10, 10, 10),
                    ]
                  )
                ),
                height: MediaQuery.of(context).size.height / 1.8,
                width: MediaQuery.of(context).size.width,
              ),
              Positioned(
                bottom: 80,
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(1),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Center(
                        child: Text(
                          "W E L C O M E   T O",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
              ),
              Positioned(
                  bottom: 50,
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(1),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Center(
                        child: Text(
                          "C U R R Y   V I R U N T H U",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 97, 159, 62),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 50.0),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              "Proceed to explore a delicious Indian Cuisine",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.2, 0.7],
                      colors: [
                        Color.fromARGB(255, 40, 40, 40),
                        Color.fromARGB(255, 40, 40, 40),
                      ]
                  )
              ),
              child: Padding(padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        _emoji(),
                        style: const TextStyle(
                          fontSize: 25
                        ),
                      ),
                      const Text(
                        "  +64     ",
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),
                      Container(
                        width: 200,
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Phone Number",
                            hintText: "41 655 1457",
                          ),

                          onChanged: (text) => setState(() {
                            print(text);
                          }),
                        )
                      )
                    ],
                  )
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: (_controller.text.length > 9 || _controller.text.length < 9) && _controller.text.length != 0 ?
              Text(
                  "Valid Phone Number Required!",
                  textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color.fromARGB(255, 100, 37, 37)
                ),
              ) : Text("")),
          const SizedBox(height: 30.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Stack(
                children: <Widget>[
                  GradientSlideToAct(
                    text: "G E T   S T A R T E D",
                    width: 400,
                    dragableIconBackgroundColor:
                    Color.fromARGB(255, 97, 159, 62),
                    textStyle: TextStyle(color: Colors.white, fontSize: 15),
                    backgroundColor: Color.fromARGB(255, 97, 159, 62),
                    onSubmit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            HapticFeedback.heavyImpact();
                            SystemSound.play(SystemSoundType.click);

                            return MainScreen(0);
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
                  ),
                  _controller.text == "" || _controller.text.length > 9 || _controller.text.length < 9  ?
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            stops: [0.2, 0.7],
                            colors: [
                              Color.fromARGB(220, 10, 10, 10),
                              Color.fromARGB(220, 10, 10, 10),
                            ],
                            // stops: [0.0, 0.1],
                          ),
                        ),
                        height: 52,
                        width: MediaQuery.of(context).size.width,
                      ) : Container(),
                  _controller.text == "" || _controller.text.length > 9 || _controller.text.length < 9  ?
                      const Positioned(
                         right: 20,
                          top: 12,
                          child: Icon(
                            Icons.block,
                            color: Color.fromARGB(255, 100, 37, 37),
                          )
                      ) : Container()
                ]
            ),
          )
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
  }

  String _emoji() {
    int flagOffset = 0x1F1E6;
    int asciiOffset = 0x41;

    String country = "AU";

    int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
    int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;

    String emoji =
        String.fromCharCode(firstChar) + String.fromCharCode(secondChar);

    return emoji;
  }

}
