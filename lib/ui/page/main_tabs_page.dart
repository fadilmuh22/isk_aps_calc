import 'package:flutter/material.dart';
import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';

import 'package:isk_aps_calc/ui/page/home_page.dart';
import 'package:isk_aps_calc/ui/page/profile_page.dart';
import 'package:isk_aps_calc/ui/page/simulation/new_simulation_page.dart';
import 'package:isk_aps_calc/constants.dart';

class MainTabs extends StatefulWidget {
  static String tag = '/main-tabs';

  @override
  _MainTabsState createState() => new _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _currentIndex = 0;

  Widget getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return HomePage(goToPage: this.goToPage);
      case 1:
        return NewSimulationPage();
      case 2:
        return ProfilePage();
    }
    return HomePage(goToPage: this.goToPage);
  }

  void goToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Konfirmasi'),
            content: new Text('Apakah Anda Yakin Ingin Keluar Dari Aplikasi?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Tidak'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Ya'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: getCurrentPage(),
        bottomNavigationBar: bottomNavigationBar(),
      ),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Constants.accentColor,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.white,
      currentIndex: _currentIndex,
      onTap: (index) {
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
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add,
          ),
          title: Text(
            'New',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
          ),
          title: Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
