import 'package:flutter/material.dart';

import 'package:isk_aps_calc/constants.dart';

import 'package:isk_aps_calc/ui/page/login_page.dart';
import 'package:isk_aps_calc/ui/page/main_tabs_page.dart';
import 'package:isk_aps_calc/ui/page/home_page.dart';
import 'package:isk_aps_calc/ui/page/simulation/dosen_page.dart';
import 'package:isk_aps_calc/ui/page/simulation/kurikulum_page.dart';
import 'package:isk_aps_calc/ui/page/simulation/new_page.dart';
import 'package:isk_aps_calc/ui/page/simulation/result_page.dart';

void main() => runApp(new MyApp());

final routes = <String, WidgetBuilder>{
  // OnBoarding.tag: (context) => OnBoarding(),
  LoginPage.tag: (context) => LoginPage(),
  MainTabs.tag: (context) => MainTabs(),
  HomePage.tag: (context) => HomePage(),
  NewSimulationPage.tag: (context) => NewSimulationPage(),
  DosenPage.tag: (context) => DosenPage(),
  KuriKulumPage.tag: (context) => KuriKulumPage(),
  ResultPage.tag: (context) => ResultPage()
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Quicksand",
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(
            color: Constants.accentColor
          ),
          textTheme: TextTheme(
            title: TextStyle(
              color: Constants.accentColor,
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