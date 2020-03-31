import 'package:flutter/material.dart';
import 'package:isk_aps_calc/contants.dart';
import 'package:isk_aps_calc/ui/page/login_page.dart';

import 'package:isk_aps_calc/ui/page/login_page.dart';
import 'package:isk_aps_calc/ui/component/bottom_main_tabs_page.dart';
import 'package:isk_aps_calc/ui/page/home_page.dart';
import 'package:isk_aps_calc/ui/page/new_simulation_page.dart';

void main() => runApp(new MyApp());

final routes = <String, WidgetBuilder>{
  // OnBoarding.tag: (context) => OnBoarding(),
  LoginPage.tag: (context) => LoginPage(),
  MainTabs.tag: (context) => MainTabs(),
  HomePage.tag: (context) => HomePage(),
  NewSimulation.tag: (context) => NewSimulation(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainTabs(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Quicksand",
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(
            color: Constants.ACCENT_COLOR
          ),
          textTheme: TextTheme(
            title: TextStyle(
              color: Constants.ACCENT_COLOR,
              fontWeight: FontWeight.w500,
              fontSize: 20
            )
          )
        ),
      ),
      routes: routes,
    );
  }
}