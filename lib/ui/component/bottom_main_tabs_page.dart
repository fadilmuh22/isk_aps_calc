import 'package:flutter/material.dart';

import 'package:isk_aps_calc/contants.dart';
import 'package:isk_aps_calc/ui/page/home_page.dart';
import 'package:isk_aps_calc/ui/page/new_simulation_page.dart';

class MainTabs extends StatefulWidget{

  static String tag = 'main-tabs';

  @override
  _MainTabsState createState() => new _MainTabsState();

}

class _MainTabsState extends State<MainTabs>{

  int _currentIndex = 0;

  Widget _getCurrentPage(){
    switch (_currentIndex){
      case 0 : return HomePage(goToPage: this.goToPage);
      case 1 : return NewSimulation();
      // case 2 : return HomePage();
    }
    // return HomePage();
  }

  void goToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final _appBar = AppBar(
      leading: IconButton( 
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back,
          color: Constants.ACCENT_COLOR,
        ),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
    );

    final _bottomNavigationBar = BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.redAccent,
      currentIndex: _currentIndex,
      onTap:(index){
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          title: Text(
            "Home",
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add,
          ),
          title: Text(
            "New",
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
          ),
          title: Text(
            "Profile",
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );

    final _scaffold = Scaffold(
      appBar: _appBar,
      body: _getCurrentPage(),
      bottomNavigationBar: _bottomNavigationBar,
    );

    return _scaffold;

  }

}