import 'package:flutter/material.dart';
import 'package:isk_aps_calc/new_simulation_page.dart';

import 'onboarding_page.dart';
import 'package:isk_aps_calc/login/login_page.dart';
import 'package:isk_aps_calc/bottom_main_tabs_page.dart';
import 'package:isk_aps_calc/home/home_page.dart';

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
            color: Colors.black
          ),
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.black,
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