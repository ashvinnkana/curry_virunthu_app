import 'package:flutter/material.dart';

import 'package:curry_virunthu_app/screens/notification.dart';
import 'package:curry_virunthu_app/screens/cart.dart';
import 'package:curry_virunthu_app/screens/home.dart';
import 'package:curry_virunthu_app/screens/profile.dart';
import 'package:curry_virunthu_app/screens/today_menu.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  int _page = 0;

  List icons = [
    Icons.home,
    Icons.label,
    Icons.shopping_cart,
    Icons.notifications,
    Icons.person,
  ];

  List pages = [
    Home(), 
    Menu(),
    Cart(),
    Notify(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: List.generate(5, (index) =>  pages[index] ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // SizedBox(width: 7),
            buildTabIcon(0),
            buildTabIcon(1),
            buildTabIcon(3),
            buildTabIcon(4),
            // SizedBox(width: 7),
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: const Icon(
          Icons.shopping_cart,
        ),
        onPressed: () => _pageController.jumpToPage(2),
      ),
    );
  }

  // void navigationTapped(int page) {
  //    _pageController.jumpToPage(page);
  //  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  buildTabIcon(int index) {
    return Container(
      margin: EdgeInsets.fromLTRB( index == 3 ? 30 : 0, 0,  index == 1 ? 30 : 0, 0),
      child: IconButton(
        icon: Icon(
          icons[index],
          size: 24.0,
        ),
        color: _page == index
            ? Theme.of(context).accentColor
            : Theme.of(context).textTheme.caption?.color,
        onPressed: () => _pageController.jumpToPage(index),
      ),
    );
  }
}
