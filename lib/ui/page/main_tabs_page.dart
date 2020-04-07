import 'package:flutter/material.dart';
import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';

import 'package:isk_aps_calc/ui/component/custom_appbar.dart';
import 'package:isk_aps_calc/ui/page/home_page.dart';
import 'package:isk_aps_calc/ui/page/simulation/new_page.dart';
import 'package:provider/provider.dart';

class MainTabs extends StatefulWidget{

  static String tag = '/main-tabs';

  @override
  _MainTabsState createState() => new _MainTabsState();

}

class _MainTabsState extends State<MainTabs>{

  int _currentIndex = 0;

  Widget _getCurrentPage(){
    switch (_currentIndex){
      case 0 : return ChangeNotifierProvider(
        create: (_) => SimulationBloc(),
        child: HomePage(goToPage: this.goToPage),
      );
      case 1 : return ChangeNotifierProvider(
        create: (_) => SimulationBloc(),
        child: NewSimulationPage(),
      );
      case 2 : return HomePage();
    }
    return HomePage();
  }

  void goToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(context) {

    _bottomNavigationBar() => BottomNavigationBar(
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
            'Home',
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
            'New',
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
            'Profile',
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
    
    return Scaffold(
      body: _getCurrentPage(),
      bottomNavigationBar: _bottomNavigationBar(),
    );

  }

}